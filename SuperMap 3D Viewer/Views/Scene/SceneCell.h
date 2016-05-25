//
//  SceneCell.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/15.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SceneModel;
@interface SceneCell : UITableViewCell

- (void)refreshData:(SceneModel *)model;

@end
