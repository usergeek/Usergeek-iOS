
#import "UsergeekClientImpl.h"
#import "UsergeekInitConfig.h"
#import "UsergeekConfiguration.h"
#import "UsergeekIdentifyStorage.h"
#import "UsergeekReportsStorage.h"
#import "UsergeekUploader.h"
#import "UsergeekUtils.h"
#import "UsergeekFormats.h"
#import "UsergeekSessionTracker.h"
#import "UsergeekSessionTrackerDelegate.h"

#ifndef USERGEEK_LOG_DEBUG
#define USERGEEK_LOG_DEBUG 0
#endif

#ifndef USERGEEK_LOG
#if USERGEEK_LOG_DEBUG
#   define USERGEEK_LOG(fmt, ...) NSLog((@"USERGEEK_LOG: " fmt), ##__VA_ARGS__)
#else
#   define USERGEEK_LOG(...)
#endif
#endif

#ifndef USERGEEK_LOG_WARN
#define USERGEEK_LOG_WARN 0
#endif

#ifndef USERGEEK_WARN
#if USERGEEK_LOG_WARN
#   define USERGEEK_WARN(fmt, ...) NSLog((@"USERGEEK_WARN: " fmt), ##__VA_ARGS__)
#else
#   define USERGEEK_WARN(...)
#endif
#endif

#ifndef USERGEEK_LOG_ERRORS
#define USERGEEK_LOG_ERRORS 1
#endif

#ifndef USERGEEK_ERROR
#if USERGEEK_LOG_ERRORS
#   define USERGEEK_ERROR(fmt, ...) NSLog((@"USERGEEK_ERROR: " fmt), ##__VA_ARGS__)
#else
#   define USERGEEK_ERROR(...)
#endif
#endif

NS_ASSUME_NONNULL_BEGIN

@interface UsergeekClientImpl ()
@property(nonatomic) UsergeekConfiguration *configuration;
@property(nonatomic) UsergeekIdentifyStorage *identifyStorage;
@property(nonatomic) UsergeekReportsStorage *reportsStorage;
@property(nonatomic) UsergeekUploader *uploader;

@property(nonatomic) NSTimer *_Nullable scheduleUploadTimer;
@property(nonatomic) BOOL scheduleUpload;
@property(nonatomic) BOOL uploading;

@property(nonatomic) NSOperationQueue *operationQueue;

@property(nonatomic, setter=setUserIdInternal:) NSString *_Nullable userId;
@property(nonatomic) NSString *deviceId;
@property(nonatomic) int sequence;

@property(nonatomic) UsergeekSessionTracker *sessionTracker;
@property(nonatomic, weak) id <UsergeekSessionTrackerDelegate> _Nullable sessionTrackerDelegate;
@end

@implementation UsergeekClientImpl

- (id <UsergeekClient>)initWithApiKey:(NSString *)apiKey initConfig:(UsergeekInitConfig *)initConfig {
    self = [super init];
    if (self) {
        self.configuration = [[UsergeekConfiguration alloc] initWithApiKey:apiKey initConfig:initConfig];
        self.identifyStorage = [[UsergeekIdentifyStorage alloc] initWithConfiguration:self.configuration];
        self.reportsStorage = [[UsergeekReportsStorage alloc] initWithConfiguration:self.configuration];
        self.uploader = [[UsergeekUploader alloc] initWithConfiguration:self.configuration];

        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 1;

        self.deviceId = [self initializeDeviceId:initConfig.initialDeviceId];
        self.userId = [self initializeUserId:initConfig.initialUserId];
        self.sequence = [self.reportsStorage getMaxSequence];

        USERGEEK_LOG(@"Usergeek initialized: deviceId '%@', userId '%@', sequence %i, configuration: %@", self.deviceId, self.userId, self.sequence, self.configuration);

        self.sessionTrackerDelegate = initConfig.sessionTrackerDelegate;
        if (initConfig.enableStartAppEvent) {
            [self logEvent:USERGEEK__DEFAULT_EVENTS__START_APP];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.sessionTrackerDelegate onStartAppEvent];
            }];
        }

        __weak __typeof(self) weakSelf = self;
        BOOL enableSessionTracking = initConfig.enableSessionTracking;
        self.sessionTracker = [UsergeekSessionTracker enableSessionTracking:initConfig.sessionTimeout listener:[UsergeekSessionTrackerListener
                listenerWithSessionStartedCallback:^(BOOL firstSession) {
                    __strong __typeof(self) self = weakSelf;
                    if (enableSessionTracking) {
                        [self logEvent:USERGEEK__DEFAULT_EVENTS__START_SESSION];
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [self.sessionTrackerDelegate onStartSessionEvent];
                        }];
                    }
                    [self flush];
                } sessionEndedCallback:^(NSTimeInterval duration) {
                    __strong __typeof(self) self = weakSelf;
                    [self flush];
                }    appDidEnterBackgroundCallback:^{
                    __strong __typeof(self) self = weakSelf;
                    [self flush];
                }         appWillTerminateCallback:^{
                    __strong __typeof(self) self = weakSelf;
                    [self flush];
                    [NSThread sleepForTimeInterval:0.5f];
                }]];
    }
    return self;
}

- (void)setUserIdInternal:(NSString *_Nullable)userId {
    _userId = userId;
}

#pragma mark Usergeek StatisticsClient interface

- (id <UsergeekClient>)setUserId:(NSString *)userId {
    if (userId.length == 0) {
        USERGEEK_WARN(@"Warning: Ignore setUserId, value is blank");
        return self;
    }
    __weak __typeof(self) weakSelf = self;
    [self.operationQueue addOperationWithBlock:^{
        __strong __typeof(self) self = weakSelf;
        [self.identifyStorage setUserId:userId];
        self.userId = userId;

        USERGEEK_LOG(@"Set new userId '%@'", userId);
    }];
    return self;
}

- (id <UsergeekClient>)resetUserId:(BOOL)regenerateDeviceId {
    __weak __typeof(self) weakSelf = self;
    [self.operationQueue addOperationWithBlock:^{
        __strong __typeof(self) self = weakSelf;
        self->_userId = nil;
        [self.identifyStorage setUserId:nil];
        if (regenerateDeviceId) {
            self.deviceId = [[NSUUID UUID] UUIDString];
            [self.identifyStorage setDeviceId:self.deviceId];
        }
    }];
    return self;
}

- (id <UsergeekClient>)logUserProperties:(UsergeekUserProperties *)userProperties {
    int64_t time = [UsergeekUtils currentTimeMillis];
    __weak __typeof(self) weakSelf = self;
    [self.operationQueue addOperationWithBlock:^{
        __strong __typeof(self) self = weakSelf;
        NSDictionary *userContent = [UsergeekFormats buildPropertiesContent:userProperties];
        [self logReport:time eventContent:nil userContent:userContent];
    }];
    return self;
}

- (id <UsergeekClient>)logEvent:(NSString *)eventName {
    int64_t time = [UsergeekUtils currentTimeMillis];
    __weak __typeof(self) weakSelf = self;
    [self.operationQueue addOperationWithBlock:^{
        __strong __typeof(self) self = weakSelf;
        NSDictionary *eventContent = [UsergeekFormats buildEventContent:eventName eventProperties:nil];
        if (eventContent) {
            [self logReport:time eventContent:eventContent userContent:nil];
        }
    }];
    return self;
}

- (id <UsergeekClient>)logEvent:(NSString *)eventName eventProperties:(UsergeekEventProperties *_Nullable)eventProperties {
    int64_t time = [UsergeekUtils currentTimeMillis];
    __weak __typeof(self) weakSelf = self;
    [self.operationQueue addOperationWithBlock:^{
        __strong __typeof(self) self = weakSelf;
        NSDictionary *eventContent = [UsergeekFormats buildEventContent:eventName eventProperties:eventProperties];
        if (eventContent) {
            [self logReport:time eventContent:eventContent userContent:nil];
        }
    }];
    return self;
}

- (void)flush {
    __weak __typeof(self) weakSelf = self;
    [self.operationQueue addOperationWithBlock:^{
        __strong __typeof(self) self = weakSelf;
        [self uploadReports];
    }];
}

#pragma mark Internal

- (void)logReport:(int64_t)time eventContent:(NSDictionary *_Nullable)eventContent userContent:(NSDictionary *_Nullable)userContent {
    int reportSequence = ++self.sequence;

    // save
    NSDictionary *report = [UsergeekFormats buildReport:self.deviceId userId:self.userId time:time sequence:reportSequence userContent:userContent eventContent:eventContent];
    NSString *reportContent = [UsergeekUtils toJson:report];
    NSString *reportDeviceContent = nil;
    if (self.configuration.deviceProperties) {
        reportDeviceContent = [UsergeekUtils toJson:[UsergeekFormats buildPropertiesContent:self.configuration.deviceProperties]];
    }

    if (self.configuration.dryRunEnabled) {
        if (eventContent) {
            USERGEEK_LOG(@"Event skipped (dryRun ON): %@ : %@", reportContent, reportDeviceContent);
        }
        if (userContent) {
            USERGEEK_LOG(@"User Property skipped (dryRun ON): %@ : %@", reportContent, reportDeviceContent);
        }
        return;
    }

    [self.reportsStorage putReport:reportSequence reportContent:reportContent device:reportDeviceContent];

    USERGEEK_LOG(@"Saved report[%i]: reportContent = '%@', reportDeviceContent = '%@'", reportSequence, reportContent, reportDeviceContent);

    // remove oldest if full
    int reportsCount = [self.reportsStorage getReportsCount];
    if (reportsCount > self.configuration.maxReportsCountInStorage) {
        int removeCount = reportsCount * self.configuration.removeReportsPercentWhenFull / 100;
        int sequenceForRemove = reportSequence - MAX(1, reportsCount - removeCount);
        BOOL removeSuccess = [self.reportsStorage removeEarlyReports:sequenceForRemove];
        if (removeSuccess) {
            USERGEEK_WARN(@"Number of reports removed: %i. Actual reports: %i", removeCount, [self.reportsStorage getReportsCount]);
        } else {
            USERGEEK_ERROR(@"Failed to remove %i reports. Existing reports: %i", removeCount, [self.reportsStorage getReportsCount]);
        }
    }

    // upload signal
    if ((reportsCount % self.configuration.uploadReportsCount) == 0) {
        [self uploadReports];
    } else {
        [self scheduleUploadReports];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshadow"

- (void)uploadReports {
    if (self.uploading) {
        return;
    } else {
        self.uploading = YES;
    }

    @try {
        int limit = self.configuration.uploadReportsCount;
        NSArray<UsergeekReport *> *reports = [self.reportsStorage getReports:limit];
        if (reports.count > 0) {
            NSInteger maxSequence = 0;
            NSString *reportsContent = [UsergeekFormats buildUploadReportsContent:reports maxSequence:&maxSequence];
            __weak __typeof(self) weakSelf = self;
            [self.uploader uploadReports:reportsContent callback:^(BOOL success) {
                __strong __typeof(self) self = weakSelf;
                [self.operationQueue addOperationWithBlock:^{
                    [self handleUploadReportsResult:maxSequence success:success];
                }];
            }];
        } else {
            self.uploading = NO;
        }
    }
    @catch (NSException *exception) {
        USERGEEK_ERROR(@"Error while prepare upload reports task. Exception: %@", exception);
    }
}

#pragma clang diagnostic pop

- (void)handleUploadReportsResult:(NSInteger)maxSequence success:(BOOL)success {
    if (success) {
        [self.reportsStorage removeEarlyReports:(int) maxSequence];
    }

    self.uploading = NO;

    if (success) {
        [self uploadReports];
    }
}

- (void)uploadReportsDelayed {
    __weak __typeof(self) weakSelf = self;
    [self.operationQueue addOperationWithBlock:^{
        __strong __typeof(self) self = weakSelf;
        self.scheduleUpload = NO;
        [self uploadReports];
    }];
}

- (void)scheduleUploadReports {
    if (self.scheduleUpload) {
        return;
    } else {
        self.scheduleUpload = YES;
    }
    NSTimeInterval delay = self.configuration.uploadReportsPeriod;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.scheduleUploadTimer invalidate];
        self.scheduleUploadTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(uploadReportsDelayed) userInfo:nil repeats:NO];
    });
}

- (NSString *)initializeDeviceId:(NSString *)initialDeviceId {
    NSString *deviceId = self.identifyStorage.deviceId;
    if (!deviceId) {
        if ([UsergeekUtils isStringEmpty:initialDeviceId]) {
            initialDeviceId = [[NSUUID UUID] UUIDString];
        }
        deviceId = initialDeviceId;
        [self.identifyStorage setDeviceId:deviceId];
    }
    return deviceId;
}

- (NSString *_Nullable)initializeUserId:(NSString *)initialUserId {
    NSString *userId = self.identifyStorage.userId;
    if (!userId) {
        if (![UsergeekUtils isStringEmpty:initialUserId]) {
            userId = initialUserId;
            [self.identifyStorage setUserId:userId];
        }
    }
    return userId;
}

@end

NS_ASSUME_NONNULL_END
