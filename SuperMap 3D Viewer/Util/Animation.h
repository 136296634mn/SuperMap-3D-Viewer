//
//  Animation.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/11.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Animation : NSObject

//  主菜单动画
+ (void)displayHomeMenu:(UIView *)view animated:(BOOL)animated;
+ (void)applyHideAnimationToHomeMenu:(UIView *)view;

//  工具菜单动画
+ (void)applyCancelAnimationToToolMenu:(UIView *)view;
+ (void)applyShowAnimationToToolMenu:(UIView *)view;

//  给兴趣点添加动画
+ (void)applyAnimationToFavorites:(UIView *)favorites completion:(void(^)())completion;

//  搜索菜单动画
+ (void)applyDisplayAnimationToSearchMenu:(UIView *)view;
+ (void)applyDismissAnimationToSearchMenu:(UIView *)view completion:(void(^)())completion;
+ (void)applyExtendAnimationToSearchMenu:(UIView *)view;
+ (void)applyShrinkAnimationToSearchMenu:(UIView *)view;

//  搜索历史列表动画
+ (void)applyDisplayAnimationToSearchHistoryMenu:(UIView *)view height:(CGFloat)height;

//  路线菜单动画
+ (void)applyDisplayAnimationToRouteMenu:(UIView *)view;
+ (void)applyDismissAnimationToRouteMenu:(UIView *)view completion:(void(^)())completion;
+ (void)applyExtendAnimationToRouteMenu:(UIView *)view;
+ (void)applyShrinkAnimationToRouteMenu:(UIView *)view;

//  全屏显示动画
+ (void)applyFullScreenAnimationToView:(UIView *)view;
+ (void)applyExitFullScreenAnimationToView:(UIView *)view;

//  设备为IPhone时场景中属性的弹出和消失动画
+ (void)applyExtendAnimationToAttributeMenu:(UIView *)view;
+ (void)applyShrinkAnimationToAttributeMenu:(UIView *)view
                            expendAnimation:(void(^)())animation
                                 completion:(void(^)())completion;

@end
