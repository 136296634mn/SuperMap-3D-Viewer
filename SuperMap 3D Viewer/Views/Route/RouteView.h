//
//  RouteView.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/28.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteView : UIView

@property (assign, readonly, nonatomic) BOOL isEditing;

//  清除搜索菜单数据
- (void)clearData;

@end
