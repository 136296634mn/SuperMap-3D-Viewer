//
//  LoaclDownloadQueue.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/15.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SceneControl, Scene;
@interface LoaclDownloadQueue : NSObject

+ (void)downloadSceneData:(void (^)(id items))response;
+ (void)downloadFavoritesData:(void (^)(id items))response sceneControl:(SceneControl *)sceneControl;
+ (void)downloadLayer3DData:(void (^)(id items))response scene:(Scene *)scene;
+ (void)downloadTerrainLayerData:(void (^)(id items))response scene:(Scene *)scene;
+ (void)downloadIServerData:(void (^)(id items))response URL:(NSString *)URLString;

@end
