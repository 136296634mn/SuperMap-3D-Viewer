//
//  FavoritesSettingCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/20.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "FavoritesSettingCell.h"
#import "FavoritesSettingModel.h"

@implementation FavoritesSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initialize];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    [self initialize];
    
    return self;
}

- (void)initialize {
    self.textLabel.font = [UIFont boldSystemFontOfSize:16];
    self.detailTextLabel.font = [UIFont systemFontOfSize:15];
}

- (void)refreshCellWithModel:(FavoritesSettingModel *)model indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.textLabel.text = @"名称";
        self.detailTextLabel.text = model.name;
    } else if (indexPath.row == 3) {
        self.textLabel.text = @"描述信息";
        self.detailTextLabel.text = model.message;
    }
}

@end
