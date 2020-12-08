

#import <Foundation/Foundation.h>

@protocol UsergeekSessionTrackerDelegate <NSObject>

/**
 * Called when "StartSession" event is logged
 */
- (void)onStartSessionEvent;

/**
 * Called when "StartApp" event is logged
 */
- (void)onStartAppEvent;

@end