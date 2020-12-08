

#import <Foundation/Foundation.h>
#import "UsergeekSessionTrackerListener.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kUsergeekSessionTrackerSessionExpiredNotification;

@interface UsergeekSessionTracker : NSObject

+ (instancetype)enableSessionTracking:(NSTimeInterval)timeout listener:(UsergeekSessionTrackerListener *)listener;

@end

NS_ASSUME_NONNULL_END
