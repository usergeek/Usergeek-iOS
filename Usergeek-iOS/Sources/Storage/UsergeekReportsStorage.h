

#import <Foundation/Foundation.h>

@class UsergeekConfiguration;
@class UsergeekReport;

NS_ASSUME_NONNULL_BEGIN

@interface UsergeekReportsStorage : NSObject

- (instancetype)initWithConfiguration:(UsergeekConfiguration *)configuration;

- (int)getMaxSequence;

- (int)getReportsCount;

- (void)putReport:(int)reportSequence reportContent:(NSString *)reportContent device:(NSString *_Nullable)device;

- (BOOL)removeEarlyReports:(int)sequenceNumber;

- (NSArray <UsergeekReport *> *_Nullable)getReports:(int)limit;

- (BOOL)dropAllTables:(BOOL)deleteDatabase;

- (BOOL)deleteDatabase;

@end

NS_ASSUME_NONNULL_END