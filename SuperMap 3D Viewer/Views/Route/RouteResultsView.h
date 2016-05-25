//
//  RouteResultsView.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/22.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteResultsView : UIView

//  获取搜索结果数据源
- (void)fetchDataSourceWithKeywords:(NSString *)keywords;

//  刷新表格
- (void)refreshMenu;

//  清除搜索结果数据源
- (void)clearDataSource;

@end
