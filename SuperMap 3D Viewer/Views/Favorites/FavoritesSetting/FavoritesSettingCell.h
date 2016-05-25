//
//  FavoritesSettingCell.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/20.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FavoritesSettingModel;
@interface FavoritesSettingCell : UITableViewCell

- (void)refreshCellWithModel:(FavoritesSettingModel *)model indexPath:(NSIndexPath *)indexPath;

@end
