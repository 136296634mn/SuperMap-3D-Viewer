//
//  FavoritesSettingViewController.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/20.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FavoritesSettingModel;
@interface FavoritesSettingViewController : UIViewController

@property (copy, nonatomic) NSString *currentTitle;
@property (strong, nonatomic) FavoritesSettingModel *model;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (copy, nonatomic) void (^deliverModel)(FavoritesSettingModel *model, NSIndexPath *indexPath);

@end
