//
//  FavoritesManageCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/21.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "FavoritesManageCell.h"
#import "FavoritesSettingModel.h"

@implementation FavoritesManageCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    return self;
}

- (void)refreshCell:(FavoritesSettingModel *)model {
    self.textLabel.text = model.name;
    self.detailTextLabel.text = model.message;
}

@end
