//
//  SceneModel.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/15.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SceneModel.h"

@implementation SceneModel

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

+ (SceneModel *)modelWithDic:(NSDictionary *)dic {
    SceneModel *sceneModel = [[SceneModel alloc] initWithDic:dic];
    return sceneModel;
}

@end
