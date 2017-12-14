//
//  SocketManager.m
//  LearnSocket
//
//  Created by zc on 2017/12/14.
//  Copyright © 2017年 IMpBear. All rights reserved.
//

#import "SocketManager.h"

@implementation SocketManager

+(SocketManager *)SharedManager{
    
    static SocketManager *socket = nil ;
    static dispatch_once_t onceToken ;
    
    dispatch_once(&onceToken, ^{
        socket = [[SocketManager alloc]init];
    });
    
    return socket ;
}

@end
