//
//  FavoritesSelectIconController.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/24.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesSelectIconController : UIViewController

@property (copy, nonatomic) NSString *currentTitle;
@property (copy, nonatomic) NSString *iconName;
@property (copy, nonatomic) void (^resetIconName)(NSString *iconName);

@end
