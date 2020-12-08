

#import <Foundation/Foundation.h>

@class UsergeekConfiguration;

NS_ASSUME_NONNULL_BEGIN

typedef void (^UsergeekUploaderFlushCallback)(BOOL success);

@interface UsergeekUploader : NSObject

- (instancetype)initWithConfiguration:(UsergeekConfiguration *)configuration;

- (void)uploadReports:(NSString *)reportsContent callback:(UsergeekUploaderFlushCallback)callback;

@end

NS_ASSUME_NONNULL_END