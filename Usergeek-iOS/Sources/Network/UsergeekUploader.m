

#import "UsergeekUploader.h"
#import "UsergeekConfiguration.h"
#import "UsergeekFormats.h"
#import "UsergeekDeflate.h"

#ifndef USERGEEK_LOG_DEBUG
#define USERGEEK_LOG_DEBUG 0
#endif

#ifndef USERGEEK_LOG
#if USERGEEK_LOG_DEBUG
#   define USERGEEK_LOG(fmt, ...) NSLog((@"USERGEEK_LOG: " fmt), ##__VA_ARGS__)
#else
#   define USERGEEK_LOG(...)
#endif
#endif

#ifndef USERGEEK_LOG_ERRORS
#define USERGEEK_LOG_ERRORS 1
#endif

#ifndef USERGEEK_ERROR
#if USERGEEK_LOG_ERRORS
#   define USERGEEK_ERROR(fmt, ...) NSLog((@"USERGEEK_ERROR: " fmt), ##__VA_ARGS__)
#else
#   define USERGEEK_ERROR(...)
#endif
#endif

#define USE_DEFLATE YES

@interface UsergeekUploader ()
@property(nonatomic, weak) UsergeekConfiguration *configuration;
@end

@implementation UsergeekUploader

- (instancetype)initWithConfiguration:(UsergeekConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.configuration = configuration;
    }
    return self;
}

- (void)uploadReports:(NSString *)reportsContent callback:(UsergeekUploaderFlushCallback)callback {
    USERGEEK_LOG(@"Will upload reports: %@", reportsContent);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.configuration.serverUrl]];
    [request setTimeoutInterval:self.configuration.uploadTimeout];

    NSData *data = [reportsContent dataUsingEncoding:NSUTF8StringEncoding];

    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%@/%@", USERGEEK__LIBRARY_NAME, USERGEEK__LIBRARY_VERSION] forHTTPHeaderField:@"User-Agent"];
    [request setValue:USERGEEK__API_VERSION forHTTPHeaderField:@"Api-Version"];
    [request setValue:self.configuration.apiKey forHTTPHeaderField:@"Api-Key"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    if (USE_DEFLATE) {
        data = [UsergeekDeflate usergeek_compress:data];
        [request setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    }

    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [data length]] forHTTPHeaderField:@"Content-Length"];

    [request setHTTPBody:data];

    [[self.configuration.URLSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL success = NO;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
            NSString *responseText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
            NSInteger statusCode = httpResponse.statusCode;
            if (statusCode == 200) {
                USERGEEK_LOG(@"Events uploaded. Response text: '%@'", responseText);
                success = YES;
            } else {
                USERGEEK_ERROR(@"Events upload failed with HTTP status code: %li. Response text: '%@'", (long) statusCode, responseText);
            }
        } else if (error) {
            USERGEEK_ERROR(@"Events upload failed with error: %@", error);
        }

        callback(success);
    }] resume];
}

@end
