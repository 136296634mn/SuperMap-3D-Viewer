//
//  AttributeModel.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/20.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "AttributeModel.h"

@implementation AttributeModel

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

+ (AttributeModel *)modelWithDic:(NSDictionary *)dic {
    AttributeModel *model = [[AttributeModel alloc] initWithDic:dic];
    return model;
}

@end
