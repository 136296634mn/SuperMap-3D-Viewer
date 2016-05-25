//
//  SMOpenScene.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/31.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void *const SMOpenSceneKey;

@class SceneControl, SceneModel;
@interface SMOpenScene : NSObject

+ (BOOL)openSceneWithSceneControl:(SceneControl *)sceneControl model:(SceneModel *)model;
+ (void)openKMLFileWithSceneControl:(SceneControl *)sceneControl kmlPath:(NSString *)path;

@end
