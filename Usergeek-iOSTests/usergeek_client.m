#import <XCTest/XCTest.h>
#import "Usergeek.h"
#import "UsergeekClientWrapper.h"
#import "UsergeekIdentifyStorage.h"
#import "UsergeekConfiguration.h"
#import "UsergeekClientImpl+Tests.h"
#import "UsergeekReportsStorage.h"

NSString *const API_KEY = @"app";

@interface usergeek_client : XCTestCase
@property(nonatomic) Usergeek *usergeek;
@property(nonatomic) UsergeekClientWrapper *usergeekInstance;
@end

@implementation usergeek_client

- (void)setUp {
    [self clearIdentifyStorage];
}

- (void)tearDown {
    [self clearIdentifyStorage];
    self.usergeekInstance = nil;
    self.usergeek = nil;
    [NSThread sleepForTimeInterval:0.2f];
}

- (void)testDefaultClientInitialization {
    [self initializeClient];
    UsergeekClientImpl *client = (UsergeekClientImpl *) self.usergeekInstance.client;
    [client logUserProperties:[[[UsergeekUserProperties new] set:@"male" forKey:@"gender"] set:@"12" forKey:@"age"]];
    [client logEvent:@"MyEvent"];
    [client flush];
    XCTAssertNotNil(client.deviceId, @"DeviceId must not be nil");
    XCTAssertTrue(client.deviceId.length > 0, @"DeviceId must not be empty string");
    XCTAssertNil(client.userId, @"UserId must nil by default");
}

- (void)testNotInitializedClient {
    Usergeek *usergeek = [[Usergeek alloc] init];
    UsergeekClientWrapper *clientWrapper = [usergeek getClient];
    XCTAssertNotNil(clientWrapper);
    UsergeekClientImpl *client = (UsergeekClientImpl *) self.usergeekInstance.client;
    XCTAssertNil(client);
}

- (void)testInitializeTwice {
    [self initializeClient];
    XCTAssertNotNil(self.usergeekInstance);
    XCTAssertEqual(self.usergeekInstance, [self.usergeek initializeWithApiKey:@"myApiKey2"]);
}

- (void)testDeviceId {
    //initial setup
    [self initializeClient];
    UsergeekClientImpl *client = (UsergeekClientImpl *) self.usergeekInstance.client;
    XCTAssertNotNil(client.deviceId, @"DeviceId must not be nil");
    XCTAssertEqualObjects(client.deviceId, client.identifyStorage.deviceId);
    XCTAssertTrue(client.deviceId.length > 0, @"DeviceId must not be empty string");
    XCTAssertNil(client.userId, @"UserId must nil by default");
    XCTAssertNil(client.identifyStorage.userId, @"UserId must nil by default");

    [client.identifyStorage removeAllData];

    //first start
    self.usergeek = [[Usergeek alloc] init];
    UsergeekInitConfig *initConfig = [[UsergeekInitConfig alloc] init];
    initConfig.initialDeviceId = @"myInitialDeviceId";
    initConfig.initialUserId = @"myInitialUserId";
    self.usergeekInstance = [self.usergeek initializeWithApiKey:API_KEY initConfig:initConfig];
    client = (UsergeekClientImpl *) self.usergeekInstance.client;
    [client waitUntilAllOperationsAreFinished];
    XCTAssertEqualObjects(initConfig.initialDeviceId, client.deviceId, @"DeviceId must be equal to passed initial id");
    XCTAssertEqualObjects(initConfig.initialDeviceId, client.identifyStorage.deviceId, @"DeviceId must be equal to passed initial id");
    XCTAssertEqualObjects(initConfig.initialUserId, client.userId, @"UserId must be equal to passed initial id");
    XCTAssertEqualObjects(initConfig.initialUserId, client.identifyStorage.userId, @"UserId must be equal to passed initial id");

    //second start
    self.usergeek = [[Usergeek alloc] init];
    self.usergeekInstance = [self.usergeek initializeWithApiKey:API_KEY initConfig:initConfig];
    client = (UsergeekClientImpl *) self.usergeekInstance.client;
    [client waitUntilAllOperationsAreFinished];
    XCTAssertEqualObjects(initConfig.initialDeviceId, client.deviceId, @"After restart: DeviceId must be equal to previously stored id");
    XCTAssertEqualObjects(initConfig.initialDeviceId, client.identifyStorage.deviceId, @"After restart: DeviceId must be equal to previously stored id");
    XCTAssertEqualObjects(initConfig.initialUserId, client.userId, @"After restart: UserId must be equal to previously stored id");
    XCTAssertEqualObjects(initConfig.initialUserId, client.identifyStorage.userId, @"After restart: UserId must be equal to previously stored id");
    [client resetUserId:NO];
    [client waitUntilAllOperationsAreFinished];
    XCTAssertEqualObjects(initConfig.initialDeviceId, client.deviceId, @"DeviceId must be equal to previously stored id after only UserId is reset");
    XCTAssertEqualObjects(initConfig.initialDeviceId, client.identifyStorage.deviceId, @"DeviceId must be equal to previously stored id after only UserId is reset");
    XCTAssertNil(client.userId, @"UserId must be nil after 'resetUserId'");
    XCTAssertNil(client.identifyStorage.userId, @"UserId must be nil after 'resetUserId'");
    [client resetUserId:YES];
    [client waitUntilAllOperationsAreFinished];
    XCTAssertNotEqualObjects(initConfig.initialDeviceId, client.deviceId, @"DeviceId must NOT be equal to previously stored id after UserId is reset with DeviceId");
    XCTAssertNotEqualObjects(initConfig.initialDeviceId, client.identifyStorage.deviceId, @"DeviceId must NOT be equal to previously stored id after UserId is reset with DeviceId");
    XCTAssertTrue(client.deviceId.length > 0, @"DeviceId must not be empty string");
    XCTAssertTrue(client.identifyStorage.deviceId.length > 0, @"DeviceId must not be empty string");
    XCTAssertNil(client.userId, @"UserId must be nil after 'resetUserId'");
    XCTAssertNil(client.identifyStorage.userId, @"UserId must be nil after 'resetUserId'");

    [client setUserId:@"user1"];
    [client waitUntilAllOperationsAreFinished];
    XCTAssertEqualObjects(client.userId, @"user1");
    XCTAssertEqualObjects(client.identifyStorage.userId, @"user1");

    [client setUserId:@"user2"];
    [client waitUntilAllOperationsAreFinished];
    XCTAssertEqualObjects(client.userId, @"user2");
    XCTAssertEqualObjects(client.identifyStorage.userId, @"user2");
}

#pragma mark Internal

- (void)initializeClient {
    self.usergeek = [[Usergeek alloc] init];
    UsergeekInitConfig *config = [[UsergeekInitConfig alloc] init];
    self.usergeekInstance = [self.usergeek initializeWithApiKey:API_KEY initConfig:config];
}

- (void)clearIdentifyStorage {
    UsergeekConfiguration *configuration = [[UsergeekConfiguration alloc] initWithApiKey:API_KEY initConfig:[[UsergeekInitConfig alloc] init]];
    UsergeekIdentifyStorage *identifyStorage = [[UsergeekIdentifyStorage alloc] initWithConfiguration:configuration];
    [identifyStorage removeAllData];
}

- (void)clearReportsStorage {
    UsergeekConfiguration *configuration = [[UsergeekConfiguration alloc] initWithApiKey:API_KEY initConfig:[[UsergeekInitConfig alloc] init]];
    UsergeekReportsStorage *identifyStorage = [[UsergeekReportsStorage alloc] initWithConfiguration:configuration];
    XCTAssertTrue([identifyStorage deleteDatabase]);
}

@end
