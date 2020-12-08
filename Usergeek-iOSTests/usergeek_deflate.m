#import <XCTest/XCTest.h>
#import "UsergeekDeflate.h"

static NSData *createArc4RandomNSDataWithSize(NSUInteger size) {
    NSMutableData *result = [NSMutableData dataWithCapacity:size];
    size_t iSize = sizeof(u_int32_t);
    NSUInteger length = size / iSize;
    for (u_int32_t i = 0; i < length; ++i) {
        u_int32_t randomBits = arc4random();
        [result appendBytes:(void *) &randomBits length:iSize];
    }
    return result;
}

@interface usergeek_deflate : XCTestCase

@end

@implementation usergeek_deflate

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSimpleData {
    NSString *in = @"Usergeek deflate Test!";
    NSData *inputData = [in dataUsingEncoding:NSUTF8StringEncoding];
    NSData *compressed = [UsergeekDeflate usergeek_compress:inputData];
    NSData *decompressed = [UsergeekDeflate usergeek_decompress:compressed];
    NSString *out = [[NSString alloc] initWithData:decompressed encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(out, in);

    XCTAssertEqualObjects(compressed, [UsergeekDeflate usergeek_compress:compressed]);
    XCTAssertEqualObjects(decompressed, [UsergeekDeflate usergeek_decompress:decompressed]);

    NSData *nilData = nil;
    XCTAssertNil([UsergeekDeflate usergeek_compress:nilData]);
    XCTAssertNil([UsergeekDeflate usergeek_decompress:nilData]);

    NSData *emptyData = [NSData data];
    XCTAssertEqualObjects(emptyData, [UsergeekDeflate usergeek_compress:emptyData]);
    XCTAssertEqualObjects(emptyData, [UsergeekDeflate usergeek_decompress:emptyData]);
    XCTAssertEqual(0, [UsergeekDeflate usergeek_compress:emptyData].length);
    XCTAssertEqual(0, [UsergeekDeflate usergeek_decompress:emptyData].length);
}

- (void)testLongData {
    NSData *inputData = createArc4RandomNSDataWithSize(10 * 1024 * 1024);
    NSData *compressed = [UsergeekDeflate usergeek_compress:inputData];
    NSData *decompressed = [UsergeekDeflate usergeek_decompress:compressed];
    XCTAssertEqualObjects(inputData, decompressed);
}

@end
