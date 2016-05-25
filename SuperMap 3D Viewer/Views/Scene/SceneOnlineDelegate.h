//
//  SceneOnlineDelegate.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/18.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SceneOnlineDelegate : NSObject <UITableViewDelegate>

- (instancetype)initWithItems:(id)items;
+ (SceneOnlineDelegate *)delegateWithItems:(id)items;
- (void)refreshData:(id)data;

@end
