#import <XCTest/XCTest.h>
#import "UsergeekFormats+Test.h"
#import "NSString+Test.h"
#import "UsergeekUserPropertyValue.h"
#import "UsergeekDevicePropertySupplier.h"
#import "UsergeekUserProperties.h"
#import "UsergeekEventProperties.h"
#import "UsergeekUtils.h"
#import "UsergeekReport.h"
#import "UsergeekInitConfig.h"

@interface usergeek_formats : XCTestCase

@end

@implementation usergeek_formats

- (void)setUp {
}

- (void)tearDown {
}

- (void)testPutPropertiesList {
    NSArray *values = @[@"a1", @"a2"];

    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertiesList:values.objectEnumerator
             propertyNameSupplier:^NSString *(NSString *property) {
                 return property;
             }
            propertyValueSupplier:^id(NSString *property) {
                return [NSString stringWithFormat:@"%@v", property];
            }
                       dictionary:jsonObject];

    XCTAssertEqual(jsonObject.count, 1);

    NSArray <NSDictionary *> *list = jsonObject[USERGEEK__CONTENT_FIELD__PROPERTIES];
    XCTAssertEqual(list.count, 2);
    NSDictionary *p1 = list[0];
    NSDictionary *p2 = list[1];
    XCTAssertEqual(p1.count, 2);
    XCTAssertEqualObjects(p1[USERGEEK__PROPERTY_FIELD__NAME], @"a1");
    XCTAssertEqualObjects(p1[USERGEEK__PROPERTY_FIELD__VALUE], @"a1v");
    XCTAssertEqual(p2.count, 2);
    XCTAssertEqualObjects(p2[USERGEEK__PROPERTY_FIELD__NAME], @"a2");
    XCTAssertEqualObjects(p2[USERGEEK__PROPERTY_FIELD__VALUE], @"a2v");
}

- (void)testPutLongPropertiesList {
    //maximum items
    NSMutableArray <NSString *> *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < PROPERTIES_MAX_COUNT; ++i) {
        [array addObject:[NSString stringWithFormat:@"a%i", i]];
    }
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertiesList:array.objectEnumerator propertyNameSupplier:^NSString *(NSString *property) {
        return property;
    }       propertyValueSupplier:^id(NSString *property) {
        return [NSString stringWithFormat:@"%@v", property];
    }                  dictionary:jsonObject];
    XCTAssertEqual(jsonObject.count, 1);
    NSArray <NSDictionary *> *list = jsonObject[USERGEEK__CONTENT_FIELD__PROPERTIES];
    XCTAssertEqual(list.count, PROPERTIES_MAX_COUNT);

    //maximum+1 items
    array = [[NSMutableArray alloc] init];
    for (int i = 0; i <= PROPERTIES_MAX_COUNT; ++i) {
        [array addObject:[NSString stringWithFormat:@"a%i", i]];
    }
    jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertiesList:array.objectEnumerator propertyNameSupplier:^NSString *(NSString *property) {
        return property;
    }       propertyValueSupplier:^id(NSString *property) {
        return [NSString stringWithFormat:@"%@v", property];
    }                  dictionary:jsonObject];
    XCTAssertEqual(jsonObject.count, 2);

    XCTAssertEqualObjects(jsonObject[USERGEEK__CONTENT_FIELD__PROPERTIES_WARNING], USERGEEK__WARNING_TRUNCATED);
    list = jsonObject[USERGEEK__CONTENT_FIELD__PROPERTIES];
    XCTAssertEqual(list.count, PROPERTIES_MAX_COUNT);

    NSDictionary *p1 = list[0];
    XCTAssertEqual(p1.count, 2);
    XCTAssertEqualObjects(p1[USERGEEK__PROPERTY_FIELD__NAME], @"a0");
    XCTAssertEqualObjects(p1[USERGEEK__PROPERTY_FIELD__VALUE], @"a0v");
}

- (void)testBuildPropertyContent {
    NSDictionary *jsonObject = [UsergeekFormats buildPropertyContent:@"pr" propertyValue:@"abc"];
    XCTAssertEqual(jsonObject.count, 2);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__NAME], @"pr");
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__VALUE], @"abc");
}

- (void)testPutEventName {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putEventName:jsonObject value:@"abc"];
    XCTAssertEqual(jsonObject.count, 1);
    XCTAssertEqualObjects(jsonObject[USERGEEK__EVENT_FIELD__NAME], @"abc");
}

- (void)testPutEventLongName {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putEventName:jsonObject value:[NSString stringWithLength:EVENT_NAME_MAX_LENGTH + 1]];
    XCTAssertEqual(jsonObject.count, 2);
    XCTAssertEqualObjects(jsonObject[USERGEEK__EVENT_FIELD__NAME], [NSString stringWithLength:EVENT_NAME_MAX_LENGTH]);
    XCTAssertEqualObjects(jsonObject[USERGEEK__EVENT_FIELD__NAME_WARNING], USERGEEK__WARNING_TRUNCATED);
}

- (void)testPutPropertyName {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertyName:jsonObject name:@"abc"];
    XCTAssertEqual(jsonObject.count, 1);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__NAME], @"abc");
}

- (void)testPutPropertyLongName {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertyName:jsonObject name:[NSString stringWithLength:PROPERTY_NAME_MAX_LENGTH + 1]];
    XCTAssertEqual(jsonObject.count, 2);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__NAME], [NSString stringWithLength:PROPERTY_NAME_MAX_LENGTH]);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__NAME_WARNING], USERGEEK__WARNING_TRUNCATED);
}

- (void)testPutPropertyStringValue {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertyValue:jsonObject value:@"abc"];
    XCTAssertEqual(jsonObject.count, 1);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__VALUE], @"abc");
}

- (void)testPutPropertyBooleanValue {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertyValue:jsonObject value:@(YES)];
    XCTAssertEqual(jsonObject.count, 1);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__VALUE], @(YES));
}

- (void)testPutPropertyLongValue {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertyValue:jsonObject value:@(123)];
    XCTAssertEqual(jsonObject.count, 1);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__VALUE], @(123));
}

- (void)testPutPropertyLongStringValue {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertyValue:jsonObject value:[NSString stringWithLength:PROPERTY_VALUE_MAX_LENGTH + 1]];
    XCTAssertEqual(jsonObject.count, 2);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__VALUE], [NSString stringWithLength:PROPERTY_VALUE_MAX_LENGTH]);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__VALUE_WARNING], USERGEEK__WARNING_TRUNCATED);
}

- (void)testPutPropertyNilValue {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertyValue:jsonObject value:nil];
    XCTAssertEqual(jsonObject.count, 1);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__VALUE], [NSNull null]);
}

- (void)testPutPropertyNullValue {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertyValue:jsonObject value:[NSNull null]];
    XCTAssertEqual(jsonObject.count, 1);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__VALUE], [NSNull null]);
}

- (void)testPutPropertyWrongNumberValue {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertyValue:jsonObject value:@(1.2f)];
    XCTAssertEqual(jsonObject.count, 1);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__VALUE_WARNING], USERGEEK__WARNING_UNSUPPORTED_TYPE);
}

- (void)testPutPropertyWrongValue {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertyValue:jsonObject value:[NSDate date]];
    XCTAssertEqual(jsonObject.count, 1);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__VALUE_WARNING], USERGEEK__WARNING_UNSUPPORTED_TYPE);
}

- (void)testPutPropertyUserPropertyValue {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertyValue:jsonObject value:[[UsergeekUserPropertyValue alloc] initWithOperation:USERGEEK__PROPERTY_OPERATION__SET value:@"abc"]];
    XCTAssertEqual(jsonObject.count, 2);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__VALUE], @"abc");
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__OPERATION], USERGEEK__PROPERTY_OPERATION__SET);

    NSMutableDictionary *jsonObject2 = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertyValue:jsonObject2 value:[[UsergeekUserPropertyValue alloc] initWithOperation:USERGEEK__PROPERTY_OPERATION__UNSET value:[NSNull null]]];
    XCTAssertEqual(jsonObject2.count, 2);
    XCTAssertEqualObjects(jsonObject2[USERGEEK__PROPERTY_FIELD__VALUE], [NSNull null]);
    XCTAssertEqualObjects(jsonObject2[USERGEEK__PROPERTY_FIELD__OPERATION], USERGEEK__PROPERTY_OPERATION__UNSET);
}

- (void)testPutPropertySupplierValue {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertyValue:jsonObject value:(id) [UsergeekDevicePropertySupplier supplierWithCallback:^NSObject * {
        return @"abc";
    }]];
    XCTAssertEqual(jsonObject.count, 1);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__VALUE], @"abc");
}

- (void)testPutPropertySupplierErrorValue {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertyValue:jsonObject value:(id) [UsergeekDevicePropertySupplier supplierWithCallback:^NSObject * {
        @throw [NSException exceptionWithName:@"exc" reason:nil userInfo:nil];
    }]];
    XCTAssertEqual(jsonObject.count, 1);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__VALUE_WARNING], USERGEEK__WARNING_RESOLVE_ERROR);
}

- (void)testPutPropertySupplierWrongNumberValue {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [UsergeekFormats putPropertyValue:jsonObject value:(id) [UsergeekDevicePropertySupplier supplierWithCallback:^NSObject * {
        return @(1.2f);
    }]];
    XCTAssertEqual(jsonObject.count, 1);
    XCTAssertEqualObjects(jsonObject[USERGEEK__PROPERTY_FIELD__VALUE_WARNING], USERGEEK__WARNING_UNSUPPORTED_TYPE);
}

- (void)testEmptyUserProperties {
    UsergeekUserProperties *userProperties = [UsergeekUserProperties instance];
    XCTAssertNil([UsergeekFormats buildPropertiesContent:userProperties]);
}

- (void)testSetUserProperties {
    UsergeekUserProperties *userProperties = [[UsergeekUserProperties instance] set:@"1" forKey:@"a"];
    NSMutableDictionary *jsonObject = [UsergeekFormats buildPropertiesContent:userProperties];
    XCTAssertEqual(jsonObject.count, 1);
    NSArray <NSDictionary *> *list = jsonObject[USERGEEK__CONTENT_FIELD__PROPERTIES];
    XCTAssertEqual(list.count, 1);
    NSDictionary *obj = list[0];
    XCTAssertEqual(obj.count, 3);
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__NAME], @"a");
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__VALUE], @"1");
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__OPERATION], USERGEEK__PROPERTY_OPERATION__SET);
}

- (void)testUnsetUserProperties {
    UsergeekUserProperties *userProperties = [[UsergeekUserProperties instance] unset:@"a"];
    NSMutableDictionary *jsonObject = [UsergeekFormats buildPropertiesContent:userProperties];
    XCTAssertEqual(jsonObject.count, 1);
    NSArray <NSDictionary *> *list = jsonObject[USERGEEK__CONTENT_FIELD__PROPERTIES];
    XCTAssertEqual(list.count, 1);
    NSDictionary *obj = list[0];
    XCTAssertEqual(obj.count, 3);
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__NAME], @"a");
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__VALUE], [NSNull null]);
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__OPERATION], USERGEEK__PROPERTY_OPERATION__UNSET);
}

- (void)testDuplicateUserProperties {
    UsergeekUserProperties *userProperties = [[[UsergeekUserProperties instance]
            set:@"1" forKey:@"a"]
            set:@"2" forKey:@"a"];
    NSMutableDictionary *jsonObject = [UsergeekFormats buildPropertiesContent:userProperties];
    XCTAssertEqual(jsonObject.count, 1);
    NSArray <NSDictionary *> *list = jsonObject[USERGEEK__CONTENT_FIELD__PROPERTIES];
    XCTAssertEqual(list.count, 1);
    NSDictionary *obj = list[0];
    XCTAssertEqual(obj.count, 3);
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__NAME], @"a");
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__VALUE], @"2");
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__OPERATION], USERGEEK__PROPERTY_OPERATION__SET);
}

- (void)testEmptyEventProperties {
    UsergeekEventProperties *eventProperties = [UsergeekEventProperties instance];
    XCTAssertNil([UsergeekFormats buildPropertiesContent:eventProperties]);
}

- (void)testSetEventProperties {
    UsergeekEventProperties *eventProperties = [[UsergeekEventProperties instance] set:@"1" forKey:@"a"];
    NSMutableDictionary *jsonObject = [UsergeekFormats buildPropertiesContent:(id) eventProperties];
    XCTAssertEqual(jsonObject.count, 1);
    NSArray <NSDictionary *> *list = jsonObject[USERGEEK__CONTENT_FIELD__PROPERTIES];
    XCTAssertEqual(list.count, 1);
    NSDictionary *obj = list[0];
    XCTAssertEqual(obj.count, 2);
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__NAME], @"a");
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__VALUE], @"1");
}

- (void)testDuplicateEventProperties {
    UsergeekEventProperties *eventProperties = [[[UsergeekEventProperties instance]
            set:@"1" forKey:@"a"]
            set:@"2" forKey:@"a"];
    NSMutableDictionary *jsonObject = [UsergeekFormats buildPropertiesContent:(id) eventProperties];
    XCTAssertEqual(jsonObject.count, 1);
    NSArray <NSDictionary *> *list = jsonObject[USERGEEK__CONTENT_FIELD__PROPERTIES];
    XCTAssertEqual(list.count, 1);
    NSDictionary *obj = list[0];
    XCTAssertEqual(obj.count, 2);
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__NAME], @"a");
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__VALUE], @"2");
}

- (void)testNonStringEventProperties {
    UsergeekEventProperties *eventProperties = [[[[UsergeekEventProperties instance]
            set:@"1" forKey:@"a"]
            set:@2 forKey:@"NSNumber"]
            set:[NSDate date] forKey:@"NSDate"];
    NSMutableDictionary *jsonObject = [UsergeekFormats buildPropertiesContent:(id) eventProperties];
    XCTAssertEqual(jsonObject.count, 1);
    NSArray <NSDictionary *> *list = jsonObject[USERGEEK__CONTENT_FIELD__PROPERTIES];
    XCTAssertEqual(list.count, 3);
    NSDictionary *obj = list[0];
    XCTAssertEqual(obj.count, 2);
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__NAME], @"a");
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__VALUE], @"1");

    obj = list[1];
    XCTAssertEqual(obj.count, 2);
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__NAME], @"NSNumber");
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__VALUE], @2);

    obj = list[2];
    XCTAssertEqual(obj.count, 2);
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__NAME], @"NSDate");
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__VALUE_WARNING], USERGEEK__WARNING_UNSUPPORTED_TYPE);
}

- (void)testBuildEventContent {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    NSDictionary *contentNil = [UsergeekFormats buildEventContent:nil eventProperties:nil];
#pragma clang diagnostic pop
    XCTAssertNil(contentNil);

#pragma clang diagnostic push
#pragma ide diagnostic ignored "NotSuperclass"
    NSDictionary *contentInvalidEventNameType = [UsergeekFormats buildEventContent:@(1) eventProperties:nil];
#pragma clang diagnostic pop
    XCTAssertNil(contentInvalidEventNameType);

    NSDictionary *contentEmpty = [UsergeekFormats buildEventContent:@"" eventProperties:nil];
    XCTAssertEqual(contentEmpty.count, 1);
    XCTAssertEqualObjects(contentEmpty[USERGEEK__EVENT_FIELD__NAME], @"");

    NSDictionary *content = [UsergeekFormats buildEventContent:@"abc" eventProperties:nil];
    XCTAssertEqual(content.count, 1);
    XCTAssertEqualObjects(content[USERGEEK__EVENT_FIELD__NAME], @"abc");

    NSDictionary *content2 = [UsergeekFormats buildEventContent:@"abc" eventProperties:[UsergeekEventProperties instance]];
    XCTAssertEqual(content2.count, 1);
    XCTAssertEqualObjects(content2[USERGEEK__EVENT_FIELD__NAME], @"abc");

    NSDictionary *content3 = [UsergeekFormats buildEventContent:@"abc" eventProperties:[[UsergeekEventProperties instance] set:@"v1" forKey:@"p1"]];
    XCTAssertEqual(content3.count, 2);
    XCTAssertEqualObjects(content3[USERGEEK__EVENT_FIELD__NAME], @"abc");
    NSArray <NSDictionary *> *list = content3[USERGEEK__CONTENT_FIELD__PROPERTIES];
    XCTAssertEqual(list.count, 1);
    NSDictionary *obj = list[0];
    XCTAssertEqual(obj.count, 2);
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__NAME], @"p1");
    XCTAssertEqualObjects(obj[USERGEEK__PROPERTY_FIELD__VALUE], @"v1");
}

- (void)testBuildReport {
    {
        NSDictionary *content = [UsergeekFormats buildReport:@"device" userId:nil time:123 sequence:1 userContent:nil eventContent:nil];
        XCTAssertEqual(content.count, 3);
        XCTAssertEqualObjects(content[USERGEEK__REPORT_FIELD__DEVICE_ID], @"device");
        XCTAssertEqualObjects(content[USERGEEK__REPORT_FIELD__TIME], @123);
        XCTAssertEqualObjects(content[USERGEEK__REPORT_FIELD__SEQUENCE], @1);
    }
    {
        NSDictionary *content = [UsergeekFormats buildReport:@"device" userId:@"user" time:123 sequence:1 userContent:@{@"a": @"b"} eventContent:@{}];
        XCTAssertEqual(content.count, 6);
        XCTAssertEqualObjects(content[USERGEEK__REPORT_FIELD__DEVICE_ID], @"device");
        XCTAssertEqualObjects(content[USERGEEK__REPORT_FIELD__USER_ID], @"user");
        XCTAssertEqualObjects(content[USERGEEK__REPORT_FIELD__TIME], @123);
        XCTAssertEqualObjects(content[USERGEEK__REPORT_FIELD__SEQUENCE], @1);
        XCTAssertEqual(((NSDictionary *) content[USERGEEK__REPORT_FIELD__EVENT]).count, 0);
        XCTAssertEqual(((NSDictionary *) content[USERGEEK__REPORT_FIELD__USER]).count, 1);
    }
}

- (void)testBuildUploadReportsContent {
    {
        NSDictionary *rep = @{@"a": @"av"};
        NSString *content = [UsergeekFormats buildUploadReportsContent:nil reports:@[[UsergeekUtils toJson:rep]]];
        NSDictionary *jsonObject;
        XCTAssertTrue([UsergeekUtils deserializeJSONObjectFrom:[content dataUsingEncoding:NSUTF8StringEncoding] result:&jsonObject resultClass:NSDictionary.class]);
        XCTAssertEqual(jsonObject.count, 3);
        XCTAssertNotNil(jsonObject[USERGEEK__REPORTS_FIELD__UPLOAD_TIME]);

        NSDictionary *library = jsonObject[USERGEEK__REPORTS_FIELD__LIBRARY];
        XCTAssertEqual(library.count, 2);
        XCTAssertEqualObjects(library[USERGEEK__LIBRARY_FIELD__NAME], USERGEEK__LIBRARY_NAME);
        XCTAssertEqualObjects(library[USERGEEK__LIBRARY_FIELD__VERSION], USERGEEK__LIBRARY_VERSION);

        NSArray *reports = jsonObject[USERGEEK__REPORTS_FIELD__REPORTS];
        XCTAssertEqual(reports.count, 1);
        XCTAssertEqualObjects(reports.firstObject, rep);
    }

    {
        NSDictionary *dev = @{@"d": @"dv"};
        NSDictionary *rep = @{@"a": @"av"};
        NSString *content = [UsergeekFormats buildUploadReportsContent:[UsergeekUtils toJson:dev] reports:@[[UsergeekUtils toJson:rep]]];
        NSDictionary *jsonObject;
        XCTAssertTrue([UsergeekUtils deserializeJSONObjectFrom:[content dataUsingEncoding:NSUTF8StringEncoding] result:&jsonObject resultClass:NSDictionary.class]);
        XCTAssertEqual(jsonObject.count, 4);
        XCTAssertNotNil(jsonObject[USERGEEK__REPORTS_FIELD__UPLOAD_TIME]);

        NSDictionary *device = jsonObject[USERGEEK__REPORTS_FIELD__DEVICE];
        XCTAssertEqual(device.count, 1);
        XCTAssertEqualObjects(device[@"d"], @"dv");

        NSArray *reports = jsonObject[USERGEEK__REPORTS_FIELD__REPORTS];
        XCTAssertEqual(reports.count, 1);
        XCTAssertEqualObjects(reports.firstObject, rep);
    }
}

- (void)testUploadReportsSingle {
    {
        int sequence = 123;
        NSString *content = @"content";

        UsergeekReport *report = [UsergeekReport reportWithSequence:sequence content:content device:nil];
        NSArray <UsergeekReport *> *reports = @[report];

        NSString *deviceContent;
        NSInteger maxSequence = 0;
        NSArray<NSString *> *result = [UsergeekFormats getUploadReports:reports deviceContent:&deviceContent maxSequence:&maxSequence];

        XCTAssertEqual(maxSequence, sequence);
        XCTAssertNil(deviceContent);
        XCTAssertEqual(result.count, 1);
        XCTAssertEqualObjects(result.firstObject, content);
    }

    {
        int sequence = 123;
        NSString *content = @"content";
        NSString *device = @"device";

        UsergeekReport *report = [UsergeekReport reportWithSequence:sequence content:content device:device];
        NSArray <UsergeekReport *> *reports = @[report];

        NSString *deviceContent;
        NSInteger maxSequence = 0;
        NSArray<NSString *> *result = [UsergeekFormats getUploadReports:reports deviceContent:&deviceContent maxSequence:&maxSequence];

        XCTAssertEqual(maxSequence, sequence);
        XCTAssertEqualObjects(deviceContent, device);
        XCTAssertEqual(result.count, 1);
        XCTAssertEqualObjects(result.firstObject, content);
    }

    {
        int sequence1 = 123;
        NSString *content1 = @"content1";
        int sequence2 = 124;
        NSString *content2 = @"content2";

        NSArray <UsergeekReport *> *reports = @[
                [UsergeekReport reportWithSequence:sequence1 content:content1 device:nil],
                [UsergeekReport reportWithSequence:sequence2 content:content2 device:nil]
        ];

        NSString *deviceContent;
        NSInteger maxSequence = 0;
        NSArray<NSString *> *result = [UsergeekFormats getUploadReports:reports deviceContent:&deviceContent maxSequence:&maxSequence];

        XCTAssertEqual(maxSequence, sequence2);
        XCTAssertNil(deviceContent);
        XCTAssertEqual(result.count, 2);
        XCTAssertEqualObjects(result[0], content1);
        XCTAssertEqualObjects(result[1], content2);
    }

    {
        int sequence1 = 123;
        NSString *content1 = @"content1";
        int sequence2 = 124;
        NSString *content2 = @"content2";
        NSString *device = @"device";

        NSArray <UsergeekReport *> *reports = @[
                [UsergeekReport reportWithSequence:sequence1 content:content1 device:device],
                [UsergeekReport reportWithSequence:sequence2 content:content2 device:device]
        ];

        NSString *deviceContent;
        NSInteger maxSequence = 0;
        NSArray<NSString *> *result = [UsergeekFormats getUploadReports:reports deviceContent:&deviceContent maxSequence:&maxSequence];

        XCTAssertEqual(maxSequence, sequence2);
        XCTAssertEqualObjects(deviceContent, device);
        XCTAssertEqual(result.count, 2);
        XCTAssertEqualObjects(result[0], content1);
        XCTAssertEqualObjects(result[1], content2);
    }

    {
        int sequence1 = 123;
        NSString *content1 = @"content1";
        NSString *device1 = @"device1";
        int sequence2 = 124;
        NSString *content2 = @"content2";
        NSString *device2 = @"device2";

        NSArray <UsergeekReport *> *reports = @[
                [UsergeekReport reportWithSequence:sequence1 content:content1 device:device1],
                [UsergeekReport reportWithSequence:sequence2 content:content2 device:device2]
        ];

        NSString *deviceContent;
        NSInteger maxSequence = 0;
        NSArray<NSString *> *result = [UsergeekFormats getUploadReports:reports deviceContent:&deviceContent maxSequence:&maxSequence];

        XCTAssertEqual(maxSequence, sequence1);
        XCTAssertEqualObjects(deviceContent, device1);
        XCTAssertEqual(result.count, 1);
        XCTAssertEqualObjects(result[0], content1);
    }

    {
        int sequence1 = 123;
        NSString *content1 = @"content1";
        NSString *device1 = @"device1";
        int sequence2 = 124;
        NSString *content2 = @"content2";
        NSString *device2 = nil;

        NSArray <UsergeekReport *> *reports = @[
                [UsergeekReport reportWithSequence:sequence1 content:content1 device:device1],
                [UsergeekReport reportWithSequence:sequence2 content:content2 device:device2]
        ];

        NSString *deviceContent;
        NSInteger maxSequence = 0;
        NSArray<NSString *> *result = [UsergeekFormats getUploadReports:reports deviceContent:&deviceContent maxSequence:&maxSequence];

        XCTAssertEqual(maxSequence, sequence1);
        XCTAssertEqualObjects(deviceContent, device1);
        XCTAssertEqual(result.count, 1);
        XCTAssertEqualObjects(result[0], content1);
    }

    {
        int sequence1 = 123;
        NSString *content1 = @"content1";
        NSString *device1 = nil;
        int sequence2 = 124;
        NSString *content2 = @"content2";
        NSString *device2 = @"device2";

        NSArray <UsergeekReport *> *reports = @[
                [UsergeekReport reportWithSequence:sequence1 content:content1 device:device1],
                [UsergeekReport reportWithSequence:sequence2 content:content2 device:device2]
        ];

        NSString *deviceContent;
        NSInteger maxSequence = 0;
        NSArray<NSString *> *result = [UsergeekFormats getUploadReports:reports deviceContent:&deviceContent maxSequence:&maxSequence];

        XCTAssertEqual(maxSequence, sequence1);
        XCTAssertNil(deviceContent);
        XCTAssertEqual(result.count, 1);
        XCTAssertEqualObjects(result[0], content1);
    }

    {
        int sequence1 = 123;
        NSString *content1 = @"content1";
        NSString *device = @"device";
        int sequence2 = 124;
        NSString *content2 = @"content2";
        int sequence3 = 125;
        NSString *content3 = @"content3";

        NSArray <UsergeekReport *> *reports = @[
                [UsergeekReport reportWithSequence:sequence1 content:content1 device:device],
                [UsergeekReport reportWithSequence:sequence2 content:content2 device:device],
                [UsergeekReport reportWithSequence:sequence3 content:content3 device:device]
        ];

        NSString *deviceContent;
        NSInteger maxSequence = 0;
        NSArray<NSString *> *result = [UsergeekFormats getUploadReports:reports deviceContent:&deviceContent maxSequence:&maxSequence];

        XCTAssertEqual(maxSequence, sequence3);
        XCTAssertEqualObjects(deviceContent, device);
        XCTAssertEqual(result.count, 3);
        XCTAssertEqualObjects(result[0], content1);
        XCTAssertEqualObjects(result[1], content2);
        XCTAssertEqualObjects(result[2], content3);
    }

    {
        int sequence1 = 123;
        NSString *content1 = @"content1";
        NSString *device = @"device";
        int sequence2 = 124;
        NSString *content2 = @"content2";
        int sequence3 = 125;
        NSString *content3 = @"content3";
        NSString *device3 = @"device3";

        NSArray <UsergeekReport *> *reports = @[
                [UsergeekReport reportWithSequence:sequence1 content:content1 device:device],
                [UsergeekReport reportWithSequence:sequence2 content:content2 device:device],
                [UsergeekReport reportWithSequence:sequence3 content:content3 device:device3]
        ];

        NSString *deviceContent;
        NSInteger maxSequence = 0;
        NSArray<NSString *> *result = [UsergeekFormats getUploadReports:reports deviceContent:&deviceContent maxSequence:&maxSequence];

        XCTAssertEqual(maxSequence, sequence2);
        XCTAssertEqualObjects(deviceContent, device);
        XCTAssertEqual(result.count, 2);
        XCTAssertEqualObjects(result[0], content1);
        XCTAssertEqualObjects(result[1], content2);
    }
}
@end
