//
//  AttributeModel.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/20.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttributeModel : NSObject

@property (strong, nonatomic) id key;
@property (strong, nonatomic) id value;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (AttributeModel *)modelWithDic:(NSDictionary *)dic;

@end
