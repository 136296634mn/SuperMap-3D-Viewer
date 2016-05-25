//
//  FavoritesSelectIconCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/24.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "FavoritesSelectIconCell.h"
#import "Helper.h"

@interface FavoritesSelectIconCell ()

@property (strong, nonatomic) UIImageView *statusImageView;
@property (strong, nonatomic) UIImage *imageOn;
@property (strong, nonatomic) UIImage *imageOff;

@end

@implementation FavoritesSelectIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initialize];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    [self initialize];
    
    return self;
}

- (void)initialize {
    self.textLabel.font = [UIFont boldSystemFontOfSize:16];
    self.textLabel.textColor = GetColor(98, 98, 98, 1.0);
    UIImageView *statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.statusImageView = statusImageView;
    self.accessoryView = self.statusImageView;
    
    self.imageOn = [UIImage imageNamed:@"checkbox_on@2x.png"];
    self.imageOff = [UIImage imageNamed:@"checkbox_off@2x.png"];
}

- (void)refreshCellWithIconName:(NSString *)name indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.imageView.image = [UIImage imageNamed:@"blupin.png"];
        self.textLabel.text = @"绿色";
    } else if (indexPath.row == 1) {
        self.imageView.image = [UIImage imageNamed:@"定位点－红.png"];
        self.textLabel.text = @"红色";
    } else if (indexPath.row == 2) {
        self.imageView.image = [UIImage imageNamed:@"定位点－蓝.png"];
        self.textLabel.text = @"蓝色";
    }
    NSString *iconName = [self iconNameWithIndexPath:indexPath];
    if ([name isEqualToString:iconName]) {
        self.statusImageView.image = self.imageOn;
    } else {
        self.statusImageView.image = self.imageOff;
    }
}

- (NSString *)iconNameWithIndexPath:(NSIndexPath *)indexPath {
    NSString *iconPath = nil;
    switch (indexPath.row) {
        case 0:
            iconPath = @"blupin.png";
            break;
        case 1:
            iconPath = @"定位点－红.png";
            break;
        case 2:
            iconPath = @"定位点－蓝.png";
            break;
    }
    return iconPath;
}

@end
