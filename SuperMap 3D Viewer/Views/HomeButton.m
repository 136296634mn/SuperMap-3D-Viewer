//
//  HomeButton.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/10.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "HomeButton.h"
#import "Helper.h"

@implementation HomeButton

- (void)awakeFromNib {
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backgroundColor = GetColor(24.0, 24.0, 24.0, 0.85);
    self.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 2);
    [self setImage:[UIImage imageNamed:@"icon_主菜单.png"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"icon_主菜单－按下.png"] forState:UIControlStateHighlighted];
}

@end
