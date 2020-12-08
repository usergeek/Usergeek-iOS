

#import "UsergeekUtils.h"
#include <sys/sysctl.h>

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

@implementation UsergeekUtils

+ (NSString *_Nullable)stringOrNilOfEmpty:(NSString *_Nullable)value {
    return [UsergeekUtils isStringEmpty:value] ? nil : value;
}

+ (BOOL)isStringEmpty:(NSString *_Nullable)value {
    return value.length == 0;
}

+ (int64_t)currentTimeMillis {
    return (int64_t) ([[NSDate date] timeIntervalSince1970] * 1000);
}

+ (NSString *_Nullable)toJson:(NSObject *_Nullable)value {
    return [UsergeekUtils toJson:value options:0];
}

+ (NSString *_Nullable)toJson:(NSObject *_Nullable)value options:(NSJSONWritingOptions)options {
    if (!value) {
        return nil;
    }
    NSString *jsonString = nil;
    @try {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:value options:options error:&error];
        if (!data || error) {
            USERGEEK_ERROR(@"JSON parsing failed. Initial object: %@. Error: %@", value, error);
            return nil;
        }
        jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    @catch (NSException *exception) {
        USERGEEK_ERROR(@"JSON parsing failed. Initial object: %@. Exception: %@", value, exception);
    }
    return jsonString;
}

+ (BOOL)deserializeJSONObjectFrom:(NSData *)data result:(id _Nonnull *_Nonnull)result resultClass:(Class)resultClass {
    NSError *deserializeError;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&deserializeError];
    if (deserializeError) {
        USERGEEK_ERROR(@"JSON deserialization error: %@", deserializeError);
        return NO;
    }
    if ([obj isKindOfClass:resultClass]) {
        *result = obj;
        return YES;
    }
    return NO;
}

/**
 * Device system uptime.
 * Do not take into consideration time zones changes.
 */
+ (NSTimeInterval)systemUptime {
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    time_t now;
    time_t uptime = -1;

    (void) time(&now);

    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
        uptime = now - boottime.tv_sec;
    }
    return uptime;
}

@end
