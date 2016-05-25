//
//  TerrainButton.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/17.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "TerrainButton.h"
#import "Helper.h"

@implementation TerrainButton

- (void)awakeFromNib {
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.cornerRadius = 10;
    self.layer.shadowOffset = CGSizeMake(0, 5);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 10;
    self.backgroundColor = GetColor(24.0, 24.0, 24.0, 0.8);
    [self setImage:[UIImage imageNamed:@"icon_图层添加.png"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"icon_图层添加－按下.png"] forState:UIControlStateHighlighted];
}

@end
