//
//  FavoritesSettingSwitchCell.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/23.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesSettingSwitchCell : UITableViewCell

@property (copy, nonatomic) void (^showFavorite)(BOOL visible);

@end
