//
//  NavigationControl.h
//  Gesture
//
//  Created by zyd on 16/3/10.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZoomControlType) {
    ZoomControlTypeMinus = 0,
    ZoomControlTypePlus,
};

@interface CompassButton : UIButton

@end

@interface ZoomContrl : UIControl

@property (assign, nonatomic) ZoomControlType type;

@end

//  自定义导航框，包括指南、放大和缩小
@interface NavigationControl : UIView

@property (copy, nonatomic) void(^north)();

@end
