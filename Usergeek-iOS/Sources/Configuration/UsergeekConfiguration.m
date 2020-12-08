

#import "UsergeekConfiguration.h"
#import "UsergeekInitConfig.h"
#import "UsergeekBaseProperties.h"
#import "UsergeekUtils.h"
#import "UsergeekFormats.h"

@interface UsergeekConfiguration ()
@property(nonatomic, readwrite) NSString *apiKey;
@property(nonatomic, readwrite) NSString *serverUrl;
@property(nonatomic, readwrite) NSTimeInterval uploadTimeout;
@property(nonatomic, readwrite) NSURLSession *URLSession;

@property(nonatomic, readwrite) int maxReportsCountInStorage;
@property(nonatomic, readwrite) int removeReportsPercentWhenFull;
@property(nonatomic, readwrite) int uploadReportsCount;
@property(nonatomic, readwrite) NSTimeInterval uploadReportsPeriod;

@property(nonatomic, readwrite) UsergeekBaseProperties *deviceProperties;

@property(nonatomic, readwrite) BOOL dryRunEnabled;
@end

@implementation UsergeekConfiguration

- (instancetype)initWithApiKey:(NSString *)apiKey initConfig:(UsergeekInitConfig *)initConfig {
    self = [super init];
    if (self) {
        self.apiKey = apiKey;
        self.serverUrl = USERGEEK__SERVER_URL;
        self.uploadTimeout = initConfig.uploadTimeout;
        self.URLSession = initConfig.URLSession ?: [NSURLSession sharedSession];

        self.maxReportsCountInStorage = 1000;
        self.removeReportsPercentWhenFull = 2;
        self.uploadReportsCount = initConfig.uploadReportsCount;
        self.uploadReportsPeriod = initConfig.uploadReportsPeriod;

        if (initConfig.devicePropertyConfig) {
            self.deviceProperties = [[UsergeekBaseProperties alloc] init];
            [initConfig.devicePropertyConfig.properties enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSObject *value, BOOL *stop) {
                self.deviceProperties.properties[key] = value;
            }];
        }

        self.dryRunEnabled = initConfig.dryRunEnabled;
    }
    return self;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.apiKey=%@", self.apiKey];
    [description appendFormat:@", self.serverUrl=%@", self.serverUrl];
    [description appendFormat:@", self.sendTimeout=%lf", self.uploadTimeout];
    [description appendFormat:@", self.maxReportsCountInStorage=%i", self.maxReportsCountInStorage];
    [description appendFormat:@", self.removeReportsPercentWhenFull=%i", self.removeReportsPercentWhenFull];
    [description appendFormat:@", self.uploadReportsCount=%i", self.uploadReportsCount];
    [description appendFormat:@", self.uploadReportsPeriod=%lf", self.uploadReportsPeriod];
    [description appendString:@">"];
    return description;
}

@end