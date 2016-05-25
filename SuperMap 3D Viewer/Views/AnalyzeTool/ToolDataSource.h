//
//  ToolDataSource.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/18.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ToolDataSource : NSObject <UITableViewDataSource>

@property (copy, nonatomic) NSString *identifier;

- (instancetype)initWithCellIdentifier:(NSString *)identifier;
- (instancetype)dataSourceWithCellIdentifier:(NSString *)identifier;

@end
