//
//  AdaptiveFit.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/25.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "AdaptiveFit.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation AdaptiveFit

+ (CGFloat)sizeFromIPone6P:(CGFloat)size {
    CGFloat newSize;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (SCREEN_WIDTH < SCREEN_HEIGHT) {
            newSize = SCREEN_WIDTH * size / 414;
        } else {
            newSize = size;
        }
    } else {
        newSize = size;
    }
    return newSize;
}

@end
