

#import <Foundation/Foundation.h>

@class UsergeekBaseProperties;
@class UsergeekReport;

NS_ASSUME_NONNULL_BEGIN

extern NSString *const USERGEEK__LIBRARY_NAME;
extern NSString *const USERGEEK__LIBRARY_VERSION;

extern NSString *const USERGEEK__SERVER_URL;
extern NSString *const USERGEEK__API_VERSION;

extern NSString *const USERGEEK__REPORTS_FIELD__UPLOAD_TIME;
extern NSString *const USERGEEK__REPORTS_FIELD__LIBRARY;
extern NSString *const USERGEEK__REPORTS_FIELD__DEVICE;
extern NSString *const USERGEEK__REPORTS_FIELD__REPORTS;

extern NSString *const USERGEEK__LIBRARY_FIELD__NAME;
extern NSString *const USERGEEK__LIBRARY_FIELD__VERSION;

extern NSString *const USERGEEK__REPORT_FIELD__DEVICE_ID;
extern NSString *const USERGEEK__REPORT_FIELD__USER_ID;
extern NSString *const USERGEEK__REPORT_FIELD__TIME;
extern NSString *const USERGEEK__REPORT_FIELD__SEQUENCE;
extern NSString *const USERGEEK__REPORT_FIELD__EVENT;
extern NSString *const USERGEEK__REPORT_FIELD__USER;

extern NSString *const USERGEEK__EVENT_FIELD__NAME;
extern NSString *const USERGEEK__EVENT_FIELD__NAME_WARNING;

extern NSString *const USERGEEK__CONTENT_FIELD__PROPERTIES;
extern NSString *const USERGEEK__CONTENT_FIELD__PROPERTIES_WARNING;

extern NSString *const USERGEEK__PROPERTY_FIELD__NAME;
extern NSString *const USERGEEK__PROPERTY_FIELD__NAME_WARNING;
extern NSString *const USERGEEK__PROPERTY_FIELD__VALUE;
extern NSString *const USERGEEK__PROPERTY_FIELD__VALUE_WARNING;
extern NSString *const USERGEEK__PROPERTY_FIELD__OPERATION;

extern NSString *const USERGEEK__WARNING_TRUNCATED;
extern NSString *const USERGEEK__WARNING_UNSUPPORTED_TYPE;
extern NSString *const USERGEEK__WARNING_RESOLVE_ERROR;

extern NSString *const USERGEEK__PROPERTY_OPERATION__SET;
extern NSString *const USERGEEK__PROPERTY_OPERATION__UNSET;

extern NSString *const USERGEEK__DEFAULT_EVENTS__START_APP;
extern NSString *const USERGEEK__DEFAULT_EVENTS__START_SESSION;

extern int const PROPERTIES_MAX_COUNT;

extern int const EVENT_NAME_MAX_LENGTH;
extern int const PROPERTY_NAME_MAX_LENGTH;
extern int const PROPERTY_VALUE_MAX_LENGTH;

typedef NSString *_Nonnull (^UsergeekFormatsPutPropertiesListNameSupplierCallback)(NSString *property);

typedef id _Nonnull (^UsergeekFormatsPutPropertiesListValueSupplierCallback)(NSString *property);

@interface UsergeekFormats : NSObject

+ (NSMutableDictionary *_Nullable)buildPropertiesContent:(UsergeekBaseProperties *_Nullable)properties;

+ (NSDictionary *)buildEventContent:(NSString *)eventName eventProperties:(UsergeekBaseProperties *_Nullable)eventProperties;

+ (NSDictionary *)buildReport:(NSString *)deviceId userId:(NSString *_Nullable)userId time:(int64_t)time sequence:(int64_t)sequence userContent:(NSDictionary *_Nullable)userContent eventContent:(NSDictionary *_Nullable)eventContent;

+ (NSString *)buildUploadReportsContent:(NSString *_Nullable)deviceContent reports:(NSArray<NSString *> *)reports;

+ (NSString *)buildUploadReportsContent:(NSArray<UsergeekReport *> *)reports maxSequence:(NSInteger *)maxSequence;

@end

NS_ASSUME_NONNULL_END
