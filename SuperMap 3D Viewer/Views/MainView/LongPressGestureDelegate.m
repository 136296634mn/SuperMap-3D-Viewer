//
//  LongPressGestureDelegate.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/20.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "LongPressGestureDelegate.h"
#import "NavigationControl.h"

@implementation LongPressGestureDelegate

#pragma mark -- UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[ZoomContrl class]]) {
        return NO;
    }
    return YES;
}

@end
