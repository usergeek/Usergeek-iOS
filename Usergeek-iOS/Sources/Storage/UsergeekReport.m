

#import "UsergeekReport.h"


@interface UsergeekReport ()
@property(nonatomic, readwrite) int sequence;
@property(nonatomic, readwrite) NSString *content;
@property(nonatomic, readwrite) NSString *_Nullable device;
@end

@implementation UsergeekReport

- (instancetype)initWithSequence:(int)sequence content:(NSString *)content device:(NSString *_Nullable)device {
    self = [super init];
    if (self) {
        self.sequence = sequence;
        self.content = content;
        self.device = device;
    }

    return self;
}

+ (instancetype)reportWithSequence:(int)sequence content:(NSString *)content device:(NSString *)device {
    return [[self alloc] initWithSequence:sequence content:content device:device];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.sequence=%i", self.sequence];
    [description appendFormat:@", self.content=%@", self.content];
    [description appendFormat:@", self.device=%@", self.device];
    [description appendString:@">"];
    return description;
}

@end