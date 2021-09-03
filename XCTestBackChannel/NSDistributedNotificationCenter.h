//
//  NSDistributedNotificationCenter.h
//  XCTestBackChannel
//
//  Created by John Scott on 9/3/21.
//

#import <Foundation/Foundation.h>

@interface NSDistributedNotificationCenter : NSNotificationCenter

+ (NSDistributedNotificationCenter *_Nonnull)defaultCenter;
// Returns the default distributed notification center - cover for [NSDistributedNotificationCenter notificationCenterForType:NSLocalNotificationCenterType]

- (void)postNotificationName:(NSNotificationName _Nonnull )name object:(nullable NSString *)object userInfo:(nullable NSDictionary *)userInfo deliverImmediately:(BOOL)deliverImmediately;

@end
