

#import <Foundation/Foundation.h>
#import "UsergeekClient.h"

@interface UsergeekClientWrapper : NSObject <UsergeekClient>

@property(nonatomic) id <UsergeekClient> client;

@end