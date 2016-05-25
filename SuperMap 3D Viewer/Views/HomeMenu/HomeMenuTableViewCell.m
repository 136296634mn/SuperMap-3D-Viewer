//
//  HomeMenuTableViewCell.m
//  SuperMap3D
//
//  Created by liuhong on 15/7/21.
//  Copyright (c) 2015年 SuperMap. All rights reserved.
//

#import "HomeMenuTableViewCell.h"

@interface HomeMenuTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *titleImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HomeMenuTableViewCell

- (void)refreshCellWithTitle:(NSString *)title andImageName:(NSString *)imageName {
    _titleImageView.image = [UIImage imageNamed:imageName];
    _titleLabel.text = title;
    _titleLabel.textColor = [UIColor whiteColor];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
