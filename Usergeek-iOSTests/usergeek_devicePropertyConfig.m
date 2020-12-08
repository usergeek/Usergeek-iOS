#import <XCTest/XCTest.h>
#import "UsergeekDevicePropertyConfig.h"
#import "UsergeekDevicePropertyFactory.h"

@interface usergeek_devicePropertyConfig : XCTestCase

@end

@implementation usergeek_devicePropertyConfig

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testAllProperties {
    UsergeekDevicePropertyConfig *devicePropertyConfig = [[[[[[[[[[[[UsergeekDevicePropertyConfig alloc] init]
            trackPlatform]
            trackModel]
            trackBrand]
            trackManufacturer]
            trackOsVersion]
            trackAppVersion]
            trackCountry]
            trackLanguage]
            trackCarrier]
            trackCacheProperty:@"my" callback:^NSString * {
                return @"prop";
            }];

    XCTAssertEqual(devicePropertyConfig.properties.count, 10);
    XCTAssertEqualObjects([((id<UsergeekDevicePropertySupplierProtocol>) devicePropertyConfig.properties[@"platform"]) getValue], @"ios");
    XCTAssertEqualObjects([((id<UsergeekDevicePropertySupplierProtocol>) devicePropertyConfig.properties[@"model"]) getValue], [UsergeekDevicePropertyFactory getHWMachine]);
    XCTAssertEqualObjects([((id<UsergeekDevicePropertySupplierProtocol>) devicePropertyConfig.properties[@"brand"]) getValue], @"Apple");
    XCTAssertEqualObjects([((id<UsergeekDevicePropertySupplierProtocol>) devicePropertyConfig.properties[@"manufacturer"]) getValue], @"Apple");
    XCTAssertEqualObjects([((id<UsergeekDevicePropertySupplierProtocol>) devicePropertyConfig.properties[@"osVersion"]) getValue], [[UIDevice currentDevice] systemVersion]);
    XCTAssertEqualObjects([((id<UsergeekDevicePropertySupplierProtocol>) devicePropertyConfig.properties[@"appVersion"]) getValue], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]);
    XCTAssertEqualObjects([((id<UsergeekDevicePropertySupplierProtocol>) devicePropertyConfig.properties[@"country"]) getValue], [UsergeekDevicePropertyFactory countryISOCode]);
    XCTAssertEqualObjects([((id<UsergeekDevicePropertySupplierProtocol>) devicePropertyConfig.properties[@"language"]) getValue], [UsergeekDevicePropertyFactory language]);
    XCTAssertEqualObjects([((id<UsergeekDevicePropertySupplierProtocol>) devicePropertyConfig.properties[@"carrier"]) getValue], [UsergeekDevicePropertyFactory carrier]);
    XCTAssertEqualObjects([((id<UsergeekDevicePropertySupplierProtocol>) devicePropertyConfig.properties[@"my"]) getValue], @"prop");

}

@end
