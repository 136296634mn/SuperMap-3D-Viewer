//
//  FavoritesSettingModel.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/21.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoritesSettingModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *iconName;
@property (copy, nonatomic) NSString *message;
@property (assign, nonatomic) BOOL visible;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (FavoritesSettingModel *)modelWithDic:(NSDictionary *)dic;

@end
