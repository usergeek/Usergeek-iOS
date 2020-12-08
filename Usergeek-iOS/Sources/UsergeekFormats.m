

#import "UsergeekFormats.h"
#import "UsergeekBaseProperties.h"
#import "UsergeekUtils.h"
#import "UsergeekUserPropertyValue.h"
#import "UsergeekDevicePropertySupplier.h"
#import "UsergeekReport.h"

NSString *const USERGEEK__LIBRARY_NAME = @"Usergeek-iOS";
NSString *const USERGEEK__LIBRARY_VERSION = @"1.0.0";

NSString *const USERGEEK__SERVER_URL = @"https://stream.usergeek.com/collect";
NSString *const USERGEEK__API_VERSION = @"1";

NSString *const USERGEEK__REPORTS_FIELD__UPLOAD_TIME = @"t";
NSString *const USERGEEK__REPORTS_FIELD__LIBRARY = @"l";
NSString *const USERGEEK__REPORTS_FIELD__DEVICE = @"d";
NSString *const USERGEEK__REPORTS_FIELD__REPORTS = @"r";

NSString *const USERGEEK__LIBRARY_FIELD__NAME = @"n";
NSString *const USERGEEK__LIBRARY_FIELD__VERSION = @"v";

NSString *const USERGEEK__REPORT_FIELD__DEVICE_ID = @"di";
NSString *const USERGEEK__REPORT_FIELD__USER_ID = @"ui";
NSString *const USERGEEK__REPORT_FIELD__TIME = @"t";
NSString *const USERGEEK__REPORT_FIELD__SEQUENCE = @"s";
NSString *const USERGEEK__REPORT_FIELD__EVENT = @"e";
NSString *const USERGEEK__REPORT_FIELD__USER = @"u";

NSString *const USERGEEK__EVENT_FIELD__NAME = @"n";
NSString *const USERGEEK__EVENT_FIELD__NAME_WARNING = @"nw";

NSString *const USERGEEK__CONTENT_FIELD__PROPERTIES = @"p";
NSString *const USERGEEK__CONTENT_FIELD__PROPERTIES_WARNING = @"pw";

NSString *const USERGEEK__PROPERTY_FIELD__NAME = @"n";
NSString *const USERGEEK__PROPERTY_FIELD__NAME_WARNING = @"nw";
NSString *const USERGEEK__PROPERTY_FIELD__VALUE = @"v";
NSString *const USERGEEK__PROPERTY_FIELD__VALUE_WARNING = @"vw";
NSString *const USERGEEK__PROPERTY_FIELD__OPERATION = @"o";

NSString *const USERGEEK__WARNING_TRUNCATED = @"truncated";
NSString *const USERGEEK__WARNING_UNSUPPORTED_TYPE = @"unsupportedType";
NSString *const USERGEEK__WARNING_RESOLVE_ERROR = @"resolveError";

NSString *const USERGEEK__PROPERTY_OPERATION__SET = @"s";
NSString *const USERGEEK__PROPERTY_OPERATION__UNSET = @"u";

NSString *const USERGEEK__DEFAULT_EVENTS__START_APP = @"StartApp";
NSString *const USERGEEK__DEFAULT_EVENTS__START_SESSION = @"StartSession";

int const PROPERTIES_MAX_COUNT = 128;

int const EVENT_NAME_MAX_LENGTH = 64;
int const PROPERTY_NAME_MAX_LENGTH = 512;
int const PROPERTY_VALUE_MAX_LENGTH = 1024;

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

@implementation UsergeekFormats

NS_ASSUME_NONNULL_BEGIN

+ (NSMutableDictionary *_Nullable)buildPropertiesContent:(UsergeekBaseProperties *_Nullable)properties {
    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
    if (properties.properties) {
        [self putPropertiesList:properties.properties.keyEnumerator propertyNameSupplier:^NSString *(NSString *property) {
            return property;
        } propertyValueSupplier:^id(NSString *property) {
            return properties.properties[property];
        } dictionary:content];
    }
    return content.count > 0 ? content : nil;
}

+ (NSDictionary *)buildEventContent:(NSString *)eventName eventProperties:(UsergeekBaseProperties *_Nullable)eventProperties {
    if (![eventName isKindOfClass:[NSString class]]) {
        USERGEEK_WARN(@"EventName must be NSString! Passed type '%@'", NSStringFromClass(eventName.class));
        return nil;
    }
    NSMutableDictionary *content = [UsergeekFormats buildPropertiesContent:eventProperties] ?: [[NSMutableDictionary alloc] init];
    [UsergeekFormats putEventName:content value:eventName];
    return content;
}

+ (NSDictionary *)buildPropertyContent:(NSString *)propertyName propertyValue:(NSObject *)propertyValue {
    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertyName:content name:propertyName];
    [UsergeekFormats putPropertyValue:content value:propertyValue];
    return content;
}

+ (NSDictionary *)buildReport:(NSString *)deviceId userId:(NSString *_Nullable)userId time:(int64_t)time sequence:(int64_t)sequence userContent:(NSDictionary *_Nullable)userContent eventContent:(NSDictionary *_Nullable)eventContent {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[USERGEEK__REPORT_FIELD__DEVICE_ID] = deviceId;
    result[USERGEEK__REPORT_FIELD__USER_ID] = userId;
    result[USERGEEK__REPORT_FIELD__TIME] = @(time);
    result[USERGEEK__REPORT_FIELD__SEQUENCE] = @(sequence);
    result[USERGEEK__REPORT_FIELD__USER] = userContent;
    result[USERGEEK__REPORT_FIELD__EVENT] = eventContent;
    return result;
}

+ (NSString *)buildUploadReportsContent:(NSString *_Nullable)deviceContent reports:(NSArray<NSString *> *)reports {
    NSString *uploadTime = [NSString stringWithFormat:@"\"%@\":%@,", USERGEEK__REPORTS_FIELD__UPLOAD_TIME, @([UsergeekUtils currentTimeMillis])];
    NSString *libraryPart = [NSString stringWithFormat:@"\"%@\":{\"%@\":\"%@\",\"%@\":\"%@\"},", USERGEEK__REPORTS_FIELD__LIBRARY, USERGEEK__LIBRARY_FIELD__NAME, USERGEEK__LIBRARY_NAME, USERGEEK__LIBRARY_FIELD__VERSION, USERGEEK__LIBRARY_VERSION];
    NSString *devicePart = ![UsergeekUtils isStringEmpty:deviceContent] ? [NSString stringWithFormat:@"\"%@\":%@,", USERGEEK__REPORTS_FIELD__DEVICE, deviceContent] : @"";
    NSString *reportsPart = reports.count > 0 ? [NSString stringWithFormat:@"\"%@\":[%@]", USERGEEK__REPORTS_FIELD__REPORTS, [reports componentsJoinedByString:@","]] : @"";
    return [NSString stringWithFormat:@"{%@%@%@%@}", uploadTime, libraryPart, devicePart, reportsPart];
}

+ (NSString *)buildUploadReportsContent:(NSArray<UsergeekReport *> *)reports maxSequence:(NSInteger *)maxSequence {
    NSAssert(reports.count > 0, @"Reports must not be empty");
    NSString *deviceContent = nil;
    NSArray<NSString *> *uploadReportsContent = [self getUploadReports:reports deviceContent:&deviceContent maxSequence:maxSequence];
    NSString *result = [UsergeekFormats buildUploadReportsContent:deviceContent reports:uploadReportsContent];
    return result;
}

NS_ASSUME_NONNULL_END

#pragma mark Internal

+ (NSArray <NSString *> *)getUploadReports:(NSArray<UsergeekReport *> *)reports deviceContent:(NSString **)deviceContent maxSequence:(NSInteger *)maxSequence{
    NSAssert(reports.count > 0, @"Reports must not be empty");
    NSMutableArray <NSString *> *result = [[NSMutableArray alloc] init];

    UsergeekReport *report = reports.firstObject;
    [result addObject:report.content];

    __block int maximalSequence = report.sequence;
    __block NSString *currentDeviceContent = report.device;

    [reports enumerateObjectsUsingBlock:^(UsergeekReport *nextReport, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            return;
        }
        NSString *nextDeviceContent = nextReport.device;

        if (nextDeviceContent == currentDeviceContent || [nextDeviceContent isEqual:currentDeviceContent]) {
            maximalSequence = nextReport.sequence;
            currentDeviceContent = nextDeviceContent;
            [result addObject:nextReport.content];
            return;
        }
        *stop = YES;
    }];

    *maxSequence = maximalSequence;
    *deviceContent = currentDeviceContent;

    return result;
}

+ (void)putPropertiesList:(NSEnumerator *)properties propertyNameSupplier:(UsergeekFormatsPutPropertiesListNameSupplierCallback)propertyNameSupplier propertyValueSupplier:(UsergeekFormatsPutPropertiesListValueSupplierCallback)propertyValueSupplier dictionary:(NSMutableDictionary *)dictionary {
    NSMutableArray <NSDictionary *> *result = [[NSMutableArray alloc] init];
    __block NSString *warning = nil;
    NSString *property = nil;
    while ((property = [properties nextObject])) {
        if (result.count >= PROPERTIES_MAX_COUNT) {
            warning = USERGEEK__WARNING_TRUNCATED;
            break;
        }
        NSString *propertyName = propertyNameSupplier(property);
        id propertyValue = propertyValueSupplier(property);
        NSDictionary *propertyContent = [UsergeekFormats buildPropertyContent:propertyName propertyValue:propertyValue];
        if (propertyContent) {
            [result addObject:propertyContent];
        }
    }
    if (result.count > 0) {
        dictionary[USERGEEK__CONTENT_FIELD__PROPERTIES] = result;
        if (warning) {
            dictionary[USERGEEK__CONTENT_FIELD__PROPERTIES_WARNING] = warning;
        }
    }
}

+ (void)putPropertyName:(NSMutableDictionary *)dictionary name:(NSString *)name {
    if (name.length > PROPERTY_NAME_MAX_LENGTH) {
        dictionary[USERGEEK__PROPERTY_FIELD__NAME] = [name substringToIndex:PROPERTY_NAME_MAX_LENGTH];
        dictionary[USERGEEK__PROPERTY_FIELD__NAME_WARNING] = USERGEEK__WARNING_TRUNCATED;
    } else {
        dictionary[USERGEEK__PROPERTY_FIELD__NAME] = name;
    }
}

+ (void)putPropertyValue:(NSMutableDictionary *)dictionary value:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        NSString *stringValue = (NSString *) value;
        if (stringValue.length > PROPERTY_VALUE_MAX_LENGTH) {
            dictionary[USERGEEK__PROPERTY_FIELD__VALUE] = [stringValue substringToIndex:PROPERTY_VALUE_MAX_LENGTH];
            dictionary[USERGEEK__PROPERTY_FIELD__VALUE_WARNING] = USERGEEK__WARNING_TRUNCATED;
        } else {
            dictionary[USERGEEK__PROPERTY_FIELD__VALUE] = stringValue;
        }
    } else if ([value isKindOfClass:[UsergeekUserPropertyValue class]]) {
        UsergeekUserPropertyValue *userPropertyValue = (UsergeekUserPropertyValue *) value;
        [UsergeekFormats putPropertyValue:dictionary value:userPropertyValue.value];
        dictionary[USERGEEK__PROPERTY_FIELD__OPERATION] = userPropertyValue.operation;
    } else if ([value isKindOfClass:[UsergeekDevicePropertySupplier class]]) {
        UsergeekDevicePropertySupplier *devicePropertySupplier = (UsergeekDevicePropertySupplier *) value;
        @try {
            [UsergeekFormats putPropertyValue:dictionary value:[devicePropertySupplier getValue]];
        }
        @catch (NSException *exception) {
            dictionary[USERGEEK__PROPERTY_FIELD__VALUE_WARNING] = USERGEEK__WARNING_RESOLVE_ERROR;
            USERGEEK_ERROR(@"Error resolve property value from supplier '%@'. Exception: %@", value, exception);
        }
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *numberValue = (NSNumber *) value;
        Boolean isFloatType = CFNumberIsFloatType((__bridge CFNumberRef) numberValue);
        if (isFloatType) {
            dictionary[USERGEEK__PROPERTY_FIELD__VALUE_WARNING] = USERGEEK__WARNING_UNSUPPORTED_TYPE;
            USERGEEK_WARN(@"Unsupported NSNumber property value type: %@", value);
        } else {
            dictionary[USERGEEK__PROPERTY_FIELD__VALUE] = numberValue;
        }
    } else if (value == nil || [value isKindOfClass:[NSNull class]]) {
        dictionary[USERGEEK__PROPERTY_FIELD__VALUE] = [NSNull null];
    } else {
        dictionary[USERGEEK__PROPERTY_FIELD__VALUE_WARNING] = USERGEEK__WARNING_UNSUPPORTED_TYPE;
        USERGEEK_WARN(@"Unsupported unknown property value type: value='%@'", value);
    }
}

+ (void)putEventName:(NSMutableDictionary *)dictionary value:(NSString *)value {
    if (value.length > EVENT_NAME_MAX_LENGTH) {
        dictionary[USERGEEK__EVENT_FIELD__NAME] = [value substringToIndex:EVENT_NAME_MAX_LENGTH];
        dictionary[USERGEEK__EVENT_FIELD__NAME_WARNING] = USERGEEK__WARNING_TRUNCATED;
    } else {
        dictionary[USERGEEK__EVENT_FIELD__NAME] = value;
    }
}

@end
