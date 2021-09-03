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

@property(nonatomic, strong) NSString *testBackchannelAppIdentifier;
@property(nonatomic, strong) NSString *testBackchannelRunnerIdentifier;

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
        self.testBackchannelRunnerIdentifier = NSUUID.UUID.UUIDString;
        self.testBackchannelAppIdentifier = NSUUID.UUID.UUIDString;
    }
    return self;
}

- (void)sentMessage:(NSString *)message {
    if (self.remoteIdentifier) {
        [NSDistributedNotificationCenter.defaultCenter postNotificationName:self.remoteIdentifier
                                                                     object:message
                                                                   userInfo:nil
                                                         deliverImmediately:YES];
    }
}

- (void)registerWithApplication:(XCTestBackChannelUIApplication*)application {
    NSMutableDictionary *launchEnvironment = [NSMutableDictionary dictionaryWithDictionary:application.launchEnvironment];
    launchEnvironment[UITestBackchannelAppIdentifier] = self.testBackchannelAppIdentifier;
    launchEnvironment[UITestBackchannelRunnerIdentifier] = self.testBackchannelRunnerIdentifier;
    application.launchEnvironment = launchEnvironment;
}

- (void)handleNotification:(NSNotification*)notification {
    [self.delegate XCTestBackChannelHandleMessage:notification.object];
}

-(NSString*)localIdentifier {
    return NSProcessInfo.processInfo.environment[UITestBackchannelAppIdentifier] ?: self.testBackchannelRunnerIdentifier;
}

-(NSString*)remoteIdentifier {
    return NSProcessInfo.processInfo.environment[UITestBackchannelRunnerIdentifier] ?: self.testBackchannelAppIdentifier;
}


-(void)setDelegate:(id<XCTestBackChannelDelegate>)delegate {
    if (_delegate) {
        [NSDistributedNotificationCenter.defaultCenter removeObserver:self];
    }
    
    if (delegate && self.localIdentifier) {
        [NSDistributedNotificationCenter.defaultCenter addObserver:self
                                                          selector:@selector(handleNotification:)
                                                              name:self.localIdentifier
                                                            object:nil];
    }
    _delegate = delegate;
}


@end
