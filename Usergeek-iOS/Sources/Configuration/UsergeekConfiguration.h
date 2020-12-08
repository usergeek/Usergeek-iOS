

#import <Foundation/Foundation.h>

@class UsergeekInitConfig;
@class UsergeekBaseProperties;

NS_ASSUME_NONNULL_BEGIN

@interface UsergeekConfiguration : NSObject

@property(nonatomic, readonly) NSString *apiKey;

@property(nonatomic, readonly) NSString *serverUrl;
@property(nonatomic, readonly) NSTimeInterval uploadTimeout;
@property(nonatomic, readonly) NSURLSession *URLSession;

@property(nonatomic, readonly) int maxReportsCountInStorage;
@property(nonatomic, readonly) int removeReportsPercentWhenFull;
@property(nonatomic, readonly) int uploadReportsCount;
@property(nonatomic, readonly) NSTimeInterval uploadReportsPeriod;

@property(nonatomic, readonly) UsergeekBaseProperties *deviceProperties;

@property(nonatomic, readonly) BOOL dryRunEnabled;

- (instancetype)initWithApiKey:(NSString *)apiKey initConfig:(UsergeekInitConfig *)initConfig;

@end

NS_ASSUME_NONNULL_END