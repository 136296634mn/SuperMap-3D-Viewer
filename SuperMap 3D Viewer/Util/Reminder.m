//
//  Reminder.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/28.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "Reminder.h"
#import <SuperMap/SuperMap.h>
#import "Reachability.h"

@implementation Reminder

+ (void)licenseReminder {
    LicenseStatus *license = [Environment getLicenseStatus];
    if (!license.isLicenseExsit) {
        UIAlertView *exsitAlertView = [[UIAlertView alloc]initWithTitle:@"提示：无许可" message:@"由于许可不存在，场景打开失败，请加入许可" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [exsitAlertView show];
    } else if (!license.isLicenseValid) {
        UIAlertView *validAlertView = [[UIAlertView alloc] initWithTitle:@"提示：许可过期"
                                                            message:@"由于许可过期，场景打开失败，请更换有效许可"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [validAlertView show];
    }
}

+ (BOOL)networkReachable {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == ReachableViaWiFi || status == ReachableViaWWAN) return YES;
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示：无网络连接" message:@"请开启蜂窝移动网络或WiFi" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    return NO;
}

+ (BOOL)networkReachableWiFi {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == ReachableViaWiFi) return YES;
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示：非WiFi网络" message:@"浏览在线数据可能会下载较大文件，建议在WiFi环境下操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    return NO;
}

@end
