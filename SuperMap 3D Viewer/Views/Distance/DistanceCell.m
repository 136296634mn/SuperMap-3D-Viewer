//
//  DistanceCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/16.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "DistanceCell.h"
#import "Bridge.h"

@interface DistanceCell ()

@property (weak, nonatomic) IBOutlet UIButton *home;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@end

@implementation DistanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    [self.home setImage:[UIImage imageNamed:@"icon_主菜单.png"] forState:UIControlStateNormal];
    [self.home setImage:[UIImage imageNamed:@"icon_主菜单－按下.png"] forState:UIControlStateHighlighted];
    [self.clearButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.clearButton setImage:[UIImage imageNamed:@"delete@2x.png"] forState:UIControlStateNormal];
}

- (IBAction)handleHomeButtonEvent:(id)sender {
    [Bridge sharedInstance].handleHomeButtonEvent();
}

- (IBAction)handleClearButtonEvent:(id)sender {
    [Bridge sharedInstance].clearAnalyzeResult();
}

@end
