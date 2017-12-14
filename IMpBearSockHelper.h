//
//  IMpBearSockHelper.h
//  LearnSocket
//
//  Created by zc on 2017/12/14.
//  Copyright © 2017年 IMpBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMpBearSockHelper : NSObject

/** 获取ip地址 */
+ (NSString *)deviceIPAdress;

/** 获取外网ip */
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
@end
