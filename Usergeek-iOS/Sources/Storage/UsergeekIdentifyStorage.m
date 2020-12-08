

#import "UsergeekIdentifyStorage.h"
#import "UsergeekConfiguration.h"
#import "UsergeekIO.h"

NSString *const UsergeekIdentifyStorage_Entity = @"identify";

NSString *const UsergeekIdentifyStorage_DeviceId = @"deviceId";
NSString *const UsergeekIdentifyStorage_UserId = @"userId";

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

@interface UsergeekIdentifyStorage ()
@property(nonatomic, weak) UsergeekConfiguration *configuration;
@end

@implementation UsergeekIdentifyStorage

- (instancetype)initWithConfiguration:(UsergeekConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.configuration = configuration;
    }
    return self;
}

- (NSString *)deviceId {
    return [self dataFromStorage][UsergeekIdentifyStorage_DeviceId];
}

- (void)setDeviceId:(NSString *)deviceId {
    [self storeValue:deviceId forKey:UsergeekIdentifyStorage_DeviceId];
}

- (NSString *)userId {
    return [self dataFromStorage][UsergeekIdentifyStorage_UserId];
}

- (void)setUserId:(NSString *)userId {
    [self storeValue:userId forKey:UsergeekIdentifyStorage_UserId];
}

- (void)removeAllData {
    NSString *path = [self filePath];
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        BOOL success = [fileManager removeItemAtPath:path error:&error];
        if (!success || error) {
            USERGEEK_ERROR(@"Removing all data failed. Error: %@", error);
        }
    }
}

- (NSString *)filePath {
    NSString *fileName = [NSString stringWithFormat:@"com_usergeek_analytics_%@_%@.dictionary", self.configuration.apiKey, UsergeekIdentifyStorage_Entity];
    return [UsergeekIO.rootDirPath stringByAppendingPathComponent:fileName];
}

- (void)storeValue:(NSObject *)value forKey:(NSString *)key {
    NSMutableDictionary *dictionary = [[self dataFromStorage] mutableCopy] ?: [[NSMutableDictionary alloc] init];
    dictionary[key] = value;

    NSString *path = [self filePath];
    BOOL success = NO;
    if (@available(iOS 11.0, *)) {
        NSError *archiveError;
        NSData *archivedData;
        @try {
            archivedData = [NSKeyedArchiver archivedDataWithRootObject:dictionary requiringSecureCoding:YES error:&archiveError];
        }
        @catch (NSException *exception) {
            USERGEEK_ERROR(@"Archive failed with exception. dictionary : %@ : %@", dictionary, exception);
        }
        if (!archivedData || archiveError) {
            USERGEEK_ERROR(@"Archive failed. Data length is %li bytes. Error: %@", (long) archivedData.length, archiveError);
            return;
        }
        NSError *writeError;
        success = [archivedData writeToFile:path options:NSDataWritingAtomic error:&writeError];
        if (!success || writeError) {
            USERGEEK_ERROR(@"Write archived data failed. Error: %@", writeError);
        }
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        @try {
            success = [NSKeyedArchiver archiveRootObject:dictionary toFile:path];
        }
        @catch (NSException *exception) {
            USERGEEK_ERROR(@"Archive failed with exception. dictionary : %@ : %@", dictionary, exception);
        }
#pragma clang diagnostic pop
    }
    if (!success) {
        USERGEEK_ERROR(@"Archive failed to file '%@'. Failed object %@.", path, dictionary);
    }
}

- (NSDictionary *)dataFromStorage {
    NSString *path = [self filePath];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        return nil;
    }
    NSError *error;
    NSDictionary *result;
    @try {
        if (@available(iOS 11.0, *)) {
            result = [NSKeyedUnarchiver unarchivedObjectOfClass:NSDictionary.class fromData:data error:&error];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            result = [NSKeyedUnarchiver unarchiveTopLevelObjectWithData:data error:&error];
#pragma clang diagnostic pop
        }
        if (!error && [result isKindOfClass:[NSDictionary class]]) {
            return result;
        } else {
            USERGEEK_ERROR(@"Unarchive failed. Got object with class %@. Error: %@", NSStringFromClass(result.class), error);
        }
    }
    @catch (NSException *exception) {
        USERGEEK_ERROR(@"Unarchive failed. Initial data length: %li bytes. Exception: %@", (long) data.length, exception);
    }
    return nil;
}

@end