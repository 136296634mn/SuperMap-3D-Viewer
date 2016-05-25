//
//  LayerModel.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/12.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "LayerModel.h"

@implementation LayerModel

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

+ (LayerModel *)modelWithDic:(NSDictionary *)dic {
    LayerModel *layerModel = [[LayerModel alloc] initWithDic:dic];
    return layerModel;
}

@end
