//
//  XCTestBackChannel.h
//  XCTestBackChannel
//
//  Created by John Scott on 9/3/21.
//

#import <Foundation/Foundation.h>

//! Project version number for XCTestBackChannel.
FOUNDATION_EXPORT double XCTestBackChannelVersionNumber;

//! Project version string for XCTestBackChannel.
FOUNDATION_EXPORT const unsigned char XCTestBackChannelVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <XCTestBackChannel/PublicHeader.h>

@class XCUIApplication;

@protocol XCTestBackChannelDelegate <NSObject>

-(void)XCTestBackChannelHandleMessage:(NSString* _Nonnull)message;

@end

@interface XCTestBackChannel : NSObject

@property (nonatomic, class, nonnull, readonly) XCTestBackChannel *sharedBackChannel;

-(void)sentMessage:(NSString* _Nonnull)message;

-(void)registerWithApplication:(XCUIApplication* _Nonnull)application;

@property (nonatomic, weak, nullable) id <XCTestBackChannelDelegate> delegate;

@end
