//
//  SceneOnlineDataSource.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/18.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TableViewCellRefreshBlock)(id cell, id item);

@interface SceneOnlineDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithItems:(id)items cellIdentifier:(NSString *)identifier refreshBlock:(TableViewCellRefreshBlock)block;
+ (SceneOnlineDataSource *)dataSourceWithItems:(id)items cellIdentifier:(NSString *)identifier refreshBlock:(TableViewCellRefreshBlock)block;
- (void)refreshData:(NSArray *)data;

@end
