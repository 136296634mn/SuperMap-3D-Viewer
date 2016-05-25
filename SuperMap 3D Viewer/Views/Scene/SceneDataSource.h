//
//  SceneDataSource.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/15.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TableViewCellRefreshBlock)(id cell, id item);

@interface SceneDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithItems:(id)items cellIdentifier:(NSString *)identifier refreshBlock:(TableViewCellRefreshBlock)block;
+ (SceneDataSource *)dataSourceWithItems:(id)items cellIdentifier:(NSString *)identifier refreshBlock:(TableViewCellRefreshBlock)block;
- (void)refreshData:(NSArray *)data;

@end
