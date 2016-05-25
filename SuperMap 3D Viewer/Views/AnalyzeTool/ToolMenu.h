//
//  ToolMenu.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/18.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ToolMenuType) {
    ToolMenuTypeNone = 0,
    ToolMenuTypeFavorites,
    ToolMenuTypeFly,
    ToolMenuTypeDistance,
    ToolMenuTypeArea,
    ToolMenuTypeVisibility,
};

@interface ToolMenu : UIView

@property (assign, nonatomic) ToolMenuType type;

- (void)refreshText:(NSString *)text;
- (void)reloadData;

//  取消按钮事件
- (void)cancelToolMenuEvent;

@end
