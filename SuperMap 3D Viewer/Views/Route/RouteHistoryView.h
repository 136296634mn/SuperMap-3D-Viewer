//
//  RouteHistoryView.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/28.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteHistoryView : UIView

//  获取路径搜索历史数据源
- (void)fetchHistoryDataSource;

//  刷新表格
- (void)refreshMenu;

@end
