//
//  SceneModel.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/15.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SceneModelType) {
    SceneModelTypeExample = 0,
    SceneModelTypeLocation,
    SceneModelTypeOnline,
};

@interface SceneModel : NSObject

@property (copy, nonatomic) NSString *senceName;
@property (copy, nonatomic) NSString *path;
@property (assign, nonatomic) SceneModelType type;
@property (copy, nonatomic) NSString *kmlPath;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (SceneModel *)modelWithDic:(NSDictionary *)dic;

@end
