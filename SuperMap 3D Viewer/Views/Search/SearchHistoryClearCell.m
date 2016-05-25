//
//  SearchHistoryClearCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/22.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SearchHistoryClearCell.h"
#import "UITableViewCell+RefreshData.h"

@interface SearchHistoryClearCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SearchHistoryClearCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor darkGrayColor];
    self.selectedBackgroundView = backgroundView;
    self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"清除历史记录";
}

- (void)refreshCell:(id)data {
}

@end
