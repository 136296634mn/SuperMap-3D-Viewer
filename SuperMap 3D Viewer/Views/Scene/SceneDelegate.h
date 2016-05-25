//
//  SceneDelegate.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/15.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SceneDelegate : NSObject <UITableViewDelegate>

- (instancetype)initWithItems:(id)items;
+ (SceneDelegate *)delegateWithItems:(id)items;
- (void)refreshData:(id)data;

@end
