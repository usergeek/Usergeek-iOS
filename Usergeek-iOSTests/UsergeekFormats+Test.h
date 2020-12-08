

#import <Foundation/Foundation.h>
#import "UsergeekFormats.h"

@interface UsergeekFormats (Test)

+ (NSDictionary *)buildPropertyContent:(NSString *)propertyName propertyValue:(NSObject *)propertyValue;

+ (void)putPropertiesList:(NSEnumerator *)properties propertyNameSupplier:(UsergeekFormatsPutPropertiesListNameSupplierCallback)propertyNameSupplier propertyValueSupplier:(UsergeekFormatsPutPropertiesListValueSupplierCallback)propertyValueSupplier dictionary:(NSMutableDictionary *)dictionary;

+ (NSArray <NSString *> *)getUploadReports:(NSArray<UsergeekReport *> *)reports deviceContent:(NSString **)deviceContent maxSequence:(NSInteger *)maxSequence;

+ (void)putPropertyName:(NSMutableDictionary *)dictionary name:(NSString *)name;

+ (void)putPropertyValue:(NSMutableDictionary *)dictionary value:(id)value;

+ (void)putEventName:(NSMutableDictionary *)dictionary value:(NSString *)value;

@end