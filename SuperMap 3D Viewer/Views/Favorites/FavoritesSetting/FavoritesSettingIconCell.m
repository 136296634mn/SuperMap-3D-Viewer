//
//  FavoritesSettingIconCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/23.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "FavoritesSettingIconCell.h"
#import "UITableViewCell+RefreshData.h"
#import "FavoritesSettingModel.h"

@interface FavoritesSettingIconCell ()

@property (strong, nonatomic) UIImageView *icon;

@end

@implementation FavoritesSettingIconCell

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
    self.textLabel.text = @"图标";
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    icon.image = [UIImage imageNamed:@"blupin.png"];
    self.icon = icon;
    self.accessoryView = self.icon;
}

- (void)refreshCell:(FavoritesSettingModel *)model {
    NSString *iconName = model.iconName;
    self.icon.image = [UIImage imageNamed:iconName];
}

@end
