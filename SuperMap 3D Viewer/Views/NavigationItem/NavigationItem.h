//
//  NavigationItem.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/14.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationItem : UIView

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) void (^popToPreviousViewController)();

@end
