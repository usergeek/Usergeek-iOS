#import <XCTest/XCTest.h>
#import "UsergeekInitConfig.h"
#import "UsergeekConfiguration.h"
#import "UsergeekFormats.h"
#import "UsergeekBaseProperties.h"

@interface usergeek_configuration : XCTestCase

@end

@implementation usergeek_configuration

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInitConfig {
    UsergeekInitConfig *initConfig = [[UsergeekInitConfig alloc] init];

    XCTAssertNil(initConfig.devicePropertyConfig);
    XCTAssertNil(initConfig.initialDeviceId);
    XCTAssertNil(initConfig.initialUserId);
    XCTAssertFalse(initConfig.enableStartAppEvent);
    XCTAssertFalse(initConfig.enableSessionTracking);

    initConfig.devicePropertyConfig = [[[UsergeekDevicePropertyConfig alloc] init] trackBrand];
    initConfig.initialDeviceId = @"d";
    initConfig.initialUserId = @"u";
    initConfig.enableStartAppEvent = YES;
    initConfig.enableSessionTracking = YES;

    XCTAssertEqualObjects(initConfig.devicePropertyConfig, [[[UsergeekDevicePropertyConfig alloc] init] trackBrand]);
    XCTAssertEqualObjects(initConfig.initialDeviceId, @"d");
    XCTAssertEqualObjects(initConfig.initialUserId, @"u");
    XCTAssertTrue(initConfig.enableStartAppEvent);
    XCTAssertTrue(initConfig.enableSessionTracking);
}

- (void)testDefault {
    NSString *apiKey = @"APIKEY";
    UsergeekInitConfig *initConfig = [[UsergeekInitConfig alloc] init];

    UsergeekConfiguration *configuration = [[UsergeekConfiguration alloc] initWithApiKey:apiKey initConfig:initConfig];
    XCTAssertEqualObjects(configuration.apiKey, apiKey);
    XCTAssertEqualObjects(configuration.serverUrl, USERGEEK__SERVER_URL);
    XCTAssertNil(configuration.deviceProperties);
}

- (void)testCustom {
    NSString *apiKey = @"APIKEY";
    UsergeekInitConfig *initConfig = [[UsergeekInitConfig alloc] init];
    initConfig.devicePropertyConfig = [[[UsergeekDevicePropertyConfig alloc] init] trackBrand];

    UsergeekConfiguration *configuration = [[UsergeekConfiguration alloc] initWithApiKey:apiKey initConfig:initConfig];
    XCTAssertEqualObjects(configuration.apiKey, apiKey);
    XCTAssertEqual(configuration.deviceProperties.properties.count, 1);
    XCTAssertTrue([configuration.deviceProperties.properties[@"brand"] conformsToProtocol:@protocol(UsergeekDevicePropertySupplierProtocol)]);
    XCTAssertEqualObjects([((id<UsergeekDevicePropertySupplierProtocol>) configuration.deviceProperties.properties[@"brand"]) getValue], @"Apple");
}

@end
