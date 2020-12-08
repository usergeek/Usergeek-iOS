#import <Foundation/Foundation.h>
#import "UsergeekClientImpl.h"

@class UsergeekIdentifyStorage;
@class UsergeekReportsStorage;
@class UsergeekConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface UsergeekClientImpl (Tests)

@property(nonatomic, readonly) NSString *_Nullable userId;
@property(nonatomic, readonly) NSString *deviceId;

@property(nonatomic, readonly) UsergeekConfiguration *configuration;


@property(nonatomic, readonly) UsergeekIdentifyStorage *identifyStorage;
@property(nonatomic, readonly) UsergeekReportsStorage *reportsStorage;

@property(nonatomic, readonly) NSOperationQueue *operationQueue;

- (void) waitUntilAllOperationsAreFinished;

@end

NS_ASSUME_NONNULL_END