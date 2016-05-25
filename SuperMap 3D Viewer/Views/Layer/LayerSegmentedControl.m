//
//  LayerSegmentedControl.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/12.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "LayerSegmentedControl.h"
#import "Helper.h"

@implementation LayerSegmentedControl

- (void)awakeFromNib {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightTextColor],NSForegroundColorAttributeName,  [UIFont systemFontOfSize:18],NSFontAttributeName,nil];
    [self setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.tintColor = GetColor(168, 168, 168, 1.0);
    self.backgroundColor = GetColor(30, 30, 30, 1.0);
}

@end
