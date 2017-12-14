//
//  SocketManager.h
//  LearnSocket
//
//  Created by zc on 2017/12/14.
//  Copyright © 2017年 IMpBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "IMpBearSockHelper.h"
@interface SocketManager : NSObject
@property(nonatomic,strong) GCDAsyncSocket *impBearSocket ;

+(SocketManager *)SharedManager  ;

@end
