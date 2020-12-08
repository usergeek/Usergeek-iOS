

#import <UIKit/UIKit.h>
#import "UsergeekSessionTracker.h"
#import "UsergeekSessionTrackerState.h"
#import "UsergeekSessionTrackerBackgroundState.h"

NSString *const kUsergeekSessionTrackerSessionExpiredNotification = @"kUsergeekSessionTrackerSessionExpiredNotification";
static NSTimeInterval UIApplicationBackgroundTaskDelay = 2;

@interface UsergeekSessionTracker ()
@property(nonatomic) NSObject *lock;
@property(nonatomic) BOOL enabled;
@property(nonatomic) NSTimeInterval timeout;
@property(nonatomic) NSTimer *timer;
@property(nonatomic) UsergeekSessionTrackerListener *listener;
@property(nonatomic) id <UsergeekSessionTrackerState> state;
@property(nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;
@end

@implementation UsergeekSessionTracker

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.lock = [[NSObject alloc] init];
        self.state = [[UsergeekSessionTrackerBackgroundState alloc] initWithTracker:self coldStart:YES];
    }
    return self;
}

- (void)enableSessionTracking:(NSTimeInterval)timeout listener:(UsergeekSessionTrackerListener *)listener {
    @synchronized (self.lock) {
        if (self.enabled) {
            return;
        }
        self.enabled = YES;
    }
    self.timeout = timeout;
    self.listener = listener;

    __weak __typeof(self) weakSelf = self;
    [self runOnMainQueue:^{
        __strong __typeof(self) self = weakSelf;
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(onUIApplicationWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
        [center addObserver:self selector:@selector(onUIApplicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
        [center addObserver:self selector:@selector(onUIApplicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [center addObserver:self selector:@selector(onUIApplicationWillTerminateNotification) name:UIApplicationWillTerminateNotification object:nil];
        [center addObserver:self selector:@selector(onUsergeekSessionTrackerSessionExpiredNotification:) name:kUsergeekSessionTrackerSessionExpiredNotification object:nil];
        UIApplication *sharedApplication = [self getSharedApplication];
        if (sharedApplication) {
            if (sharedApplication.applicationState != UIApplicationStateBackground) {
                [self onUIApplicationDidBecomeActiveNotification];
            }
        }
    }];
}

+ (instancetype)enableSessionTracking:(NSTimeInterval)timeout listener:(UsergeekSessionTrackerListener *)listener {
    UsergeekSessionTracker *tracker = [[UsergeekSessionTracker alloc] init];
    [tracker enableSessionTracking:timeout listener:listener];
    return tracker;
}

- (void)runOnMainQueue:(void (^)(void))block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

#pragma mark Internal

- (void)onUIApplicationWillResignActiveNotification {
    [self endBackgroundTask];
}

- (void)onUIApplicationDidBecomeActiveNotification {
    NSAssert([NSThread isMainThread], @"Must be called from the main thread!");
    UIApplication *sharedApplication = [self getSharedApplication];
    if (sharedApplication == nil) {
        //app extension case
        return;
    }
    [self endBackgroundTask];
    self.state = [self.state toForeground:self.listener timer:self.timer];
}

- (void)onUIApplicationWillTerminateNotification {
    NSAssert([NSThread isMainThread], @"Must be called from the main thread!");
    UIApplication *sharedApplication = [self getSharedApplication];
    if (sharedApplication == nil) {
        //app extension case
        return;
    }
    self.listener.appWillTerminateCallback();
}

- (void)onUIApplicationDidEnterBackgroundNotification {
    NSAssert([NSThread isMainThread], @"Must be called from the main thread!");
    UIApplication *sharedApplication = [self getSharedApplication];
    if (sharedApplication == nil) {
        //app extension case
        return;
    }
    [self endBackgroundTask];
    __weak __typeof(self) weakSelf = self;
    self.backgroundTaskId = [sharedApplication beginBackgroundTaskWithName:@"UsergeekSessionTrackerBgTask" expirationHandler:^{
        __strong __typeof(self) self = weakSelf;
        [self endBackgroundTask];
    }];
    self.state = [self.state toBackground:self.listener timer:self.timer];
}

- (void)onUsergeekSessionTrackerSessionExpiredNotification:(NSNotification *)notification {
    self.state = [self.state sessionExpirationEventOn:notification.object listener:self.listener];
    //to be sure that the request will reach the server
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (UIApplicationBackgroundTaskDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endBackgroundTask];
    });
}

- (void)endBackgroundTask {
    if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
        UIApplication *sharedApplication = [self getSharedApplication];
        if (!sharedApplication) {
            return;
        }
        [sharedApplication endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId = UIBackgroundTaskInvalid;
    }
}

- (UIApplication *)getSharedApplication {
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if (UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return [UIApplication performSelector:@selector(sharedApplication)];
    }
    return nil;
}

@end

