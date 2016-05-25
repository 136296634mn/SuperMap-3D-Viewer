//
//  FavoritesSettingSwitchCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/23.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "FavoritesSettingSwitchCell.h"
#import "UITableViewCell+RefreshData.h"
#import "FavoritesSettingModel.h"

@interface FavoritesSettingSwitchCell ()

@property (strong, nonatomic) UISwitch *displaySwitch;
@property (strong, nonatomic) FavoritesSettingModel *model;

@end

@implementation FavoritesSettingSwitchCell

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
    self.textLabel.text = @"在场景中显示";
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UISwitch *displaySwitch = [[UISwitch alloc] init];
    [displaySwitch addTarget:self
                      action:@selector(handleDisplaySwitchEvent:)
            forControlEvents:UIControlEventValueChanged];
    self.displaySwitch = displaySwitch;
    self.accessoryView = self.displaySwitch;
}

- (void)handleDisplaySwitchEvent:(UISwitch *)displaySwitch {
    if (self.showFavorite) {
        self.showFavorite(displaySwitch.isOn);
    }
}

- (void)refreshCell:(FavoritesSettingModel *)model {
    self.model = model;
    self.displaySwitch.on = self.model.visible;
}

@end
