

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UsergeekUserPropertyValue : NSObject
@property(nonatomic, readonly) NSString *operation;
@property(nonatomic, readonly) NSObject *_Nullable value;

- (instancetype)initWithOperation:(NSString *)operation value:(NSObject *_Nullable)value;

@end

NS_ASSUME_NONNULL_END