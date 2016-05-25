//
//  Bridge.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/12.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "Bridge.h"

@implementation Bridge

+ (instancetype)sharedInstance {
    static Bridge *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[super allocWithZone:NULL] init];
    });
    return singleton;
}

@end
