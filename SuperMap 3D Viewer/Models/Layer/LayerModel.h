//
//  LayerModel.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/12.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LayerModelType) {
    LayerModelTypeLayer3D = 0,
    LayerModelTypeTerrainLayer,
};

@interface LayerModel : NSObject

@property (copy, nonatomic) NSString *layerName;
@property (copy, nonatomic) NSString *captionName;
@property (assign, nonatomic) BOOL visible;
@property (assign, nonatomic) BOOL selectable;
@property (assign, nonatomic) LayerModelType type;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (LayerModel *)modelWithDic:(NSDictionary *)dic;

@end
