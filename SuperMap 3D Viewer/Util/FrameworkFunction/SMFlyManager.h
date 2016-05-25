//
//  SMFlyManager.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/31.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SceneControl;
@interface SMFlyManager : NSObject

//  传入指定飞行文件或传入nil默认加载以场景名为文件名的飞行文件
+ (void)prepareFlyRoutesWithSceneControl:(SceneControl *)sceneControl
                                     fpf:(NSString *)fpfName
                              completion:(void (^)(id responseObject))completion;

@end
