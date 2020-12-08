

#import <XCTest/XCTest.h>
#import "UsergeekConfiguration.h"
#import "UsergeekIdentifyStorage.h"
#import "UsergeekInitConfig.h"

@interface usergeek_identifyStorage : XCTestCase
@property(nonatomic) UsergeekConfiguration *configuration;
@property(nonatomic) UsergeekIdentifyStorage *identifyStorage;
@end

@implementation usergeek_identifyStorage

- (void)setUp {
    NSString *apiKey = @"APIKEY";
    self.configuration = [[UsergeekConfiguration alloc] initWithApiKey:apiKey initConfig:[[UsergeekInitConfig alloc] init]];
    self.identifyStorage = [[UsergeekIdentifyStorage alloc] initWithConfiguration:self.configuration];
    [self.identifyStorage removeAllData];
}

- (void)tearDown {
    self.identifyStorage = nil;
}

- (void)testDeviceId {
    NSString *deviceId = @"abc";
    XCTAssertNil(self.identifyStorage.deviceId);

    [self.identifyStorage setDeviceId:deviceId];
    XCTAssertEqualObjects(self.identifyStorage.deviceId, deviceId);
}

- (void)testUserId {
    NSString *userId = @"abc";
    XCTAssertNil(self.identifyStorage.userId);

    [self.identifyStorage setUserId:userId];
    XCTAssertEqualObjects(self.identifyStorage.userId, userId);
}

- (void)testSetPerformance {
    NSString *userId = @"abc";

    [self measureBlock:^{
        [self.identifyStorage setUserId:userId];
    }];
}

@end
