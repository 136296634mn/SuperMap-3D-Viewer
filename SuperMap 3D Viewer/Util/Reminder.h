//
//  Reminder.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/28.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Reminder : NSObject

//  许可过期提醒
+ (void)licenseReminder;

//  提示网络连接
+ (BOOL)networkReachable;

//  提示网络是否为WIFI
+ (BOOL)networkReachableWiFi;

@end
