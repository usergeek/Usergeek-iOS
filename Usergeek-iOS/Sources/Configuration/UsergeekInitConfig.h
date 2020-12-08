

#import <Foundation/Foundation.h>
#import "UsergeekDevicePropertyConfig.h"

@protocol UsergeekSessionTrackerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface UsergeekInitConfig : NSObject

@property(nonatomic) UsergeekDevicePropertyConfig *_Nullable devicePropertyConfig;
@property(nonatomic) NSString *_Nullable initialDeviceId;
@property(nonatomic) NSString *_Nullable initialUserId;

@property(nonatomic) NSURLSession *_Nullable URLSession;

@property(nonatomic) BOOL enableStartAppEvent;
@property(nonatomic) BOOL enableSessionTracking;
@property(nonatomic) NSTimeInterval sessionTimeout;

@property(nonatomic) NSTimeInterval uploadTimeout;
@property(nonatomic) int uploadReportsCount;
@property(nonatomic) NSTimeInterval uploadReportsPeriod;

@property(nonatomic) BOOL dryRunEnabled;

@property(nonatomic, weak) id<UsergeekSessionTrackerDelegate>_Nullable sessionTrackerDelegate;

@end

NS_ASSUME_NONNULL_END