//
//  RouteBar.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/28.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteBar : UIView

@property (assign, readonly, nonatomic) BOOL isEditing;

- (void)setActiveTextFieldText:(NSString *)text;
- (void)nextTextField;
- (void)clearContent;
- (void)setOrigin:(NSString *)origin destination:(NSString *)destination;

@end
