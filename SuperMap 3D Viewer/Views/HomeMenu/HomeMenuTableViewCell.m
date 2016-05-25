//
//  HomeMenuTableViewCell.m
//  SuperMap3D
//
//  Created by liuhong on 15/7/21.
//  Copyright (c) 2015年 SuperMap. All rights reserved.
//

#import "HomeMenuTableViewCell.h"

#define TITLELABEL_FONT_SIZE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 20 : 15)

@interface HomeMenuTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *titleImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HomeMenuTableViewCell

- (void)refreshCellWithTitle:(NSString *)title andImageName:(NSString *)imageName {

    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
    NSData *imageData = [[NSData alloc] initWithContentsOfFile:imagePath];
    _titleImageView.image = [UIImage imageWithData:imageData];
    _titleLabel.text = title;
    _titleLabel.font = [UIFont systemFontOfSize:TITLELABEL_FONT_SIZE];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
