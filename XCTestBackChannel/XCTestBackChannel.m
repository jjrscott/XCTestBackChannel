//
//  XCTestBackChannel.m
//  XCTestBackChannel
//
//  Created by John Scott on 9/3/21.
//

#import <Foundation/Foundation.h>

#import "XCTestBackChannel.h"
#import "XCTestBackChannelUIApplication.h"
#import "NSDistributedNotificationCenter.h"

#define UITestBackchannelAppIdentifier @"UITestBackchannelAppIdentifier"
#define UITestBackchannelRunnerIdentifier @"UITestBackchannelRunnerIdentifier"

@interface XCTestBackChannel ()

@property(nonatomic, strong) NSString *localIdentifier;
@property(nonatomic, strong) NSString *remoteIdentifier;

@end

@implementation XCTestBackChannel

+ (instancetype)sharedBackChannel
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.localIdentifier = NSProcessInfo.processInfo.environment[UITestBackchannelAppIdentifier] ?: NSUUID.UUID.UUIDString;
        self.remoteIdentifier = NSProcessInfo.processInfo.environment[UITestBackchannelRunnerIdentifier] ?: NSUUID.UUID.UUIDString;
        
        [NSDistributedNotificationCenter.defaultCenter addObserver:self
                                                          selector:@selector(handleNotification:)
                                                              name:self.localIdentifier
                                                            object:nil];
    }
    return self;
}

+(void)initialize {
    [self sharedBackChannel];
}

- (void)sendMessage:(NSString *)message {
    if (self.remoteIdentifier) {
        [NSDistributedNotificationCenter.defaultCenter postNotificationName:self.remoteIdentifier
                                                                     object:message
                                                                   userInfo:nil
                                                         deliverImmediately:YES];
    }
}

- (void)registerWithApplication:(XCTestBackChannelUIApplication*)application {
    NSMutableDictionary *launchEnvironment = [NSMutableDictionary dictionaryWithDictionary:application.launchEnvironment];
    launchEnvironment[UITestBackchannelAppIdentifier] = self.remoteIdentifier;
    launchEnvironment[UITestBackchannelRunnerIdentifier] = self.localIdentifier;
    application.launchEnvironment = launchEnvironment;
}

- (void)handleNotification:(NSNotification*)notification {
    [self.delegate XCTestBackChannelHandleMessage:notification.object];
}

@end
