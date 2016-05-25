//
//  FavoritesSettingModel.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/21.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "FavoritesSettingModel.h"

@implementation FavoritesSettingModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (FavoritesSettingModel *)modelWithDic:(NSDictionary *)dic {
    FavoritesSettingModel *model = [[FavoritesSettingModel alloc] initWithDic:dic];
    return model;
}

@end
