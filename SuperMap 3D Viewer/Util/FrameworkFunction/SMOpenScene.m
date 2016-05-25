//
//  SMOpenScene.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/31.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SMOpenScene.h"
#import <SuperMap/SuperMap.h>
#import "SceneModel.h"
#import <objc/runtime.h>
#import "LocalDownload.h"
#import "Reminder.h"

void *const SMOpenSceneKey = (void *)"SMOpenSceneKey";

@implementation SMOpenScene

+ (BOOL)openSceneWithSceneControl:(SceneControl *)sceneControl model:(SceneModel *)model {
    BOOL isSuccess = NO;
    if (model.type == SceneModelTypeExample) {
        isSuccess = [self openExampleSceneWithSceneControl:sceneControl model:model];
    } else if (model.type == SceneModelTypeLocation) {
        isSuccess = [self openLocationSceneWithSceneControl:sceneControl model:model];
    } else if (model.type == SceneModelTypeOnline) {
        isSuccess = [self openOnlineSceneWithSceneControl:sceneControl model:model];
    }
    sceneControl.navigationControlVisible = NO;//   每次都设置默认导航条不可见
    
    return isSuccess;
}

//  打开范例场景
+ (BOOL)openExampleSceneWithSceneControl:(SceneControl *)sceneControl model:(SceneModel *)model {
    BOOL isOpen = [sceneControl.scene openSceneWithUrl:model.path Name:model.senceName Password:@"supermap"];
    [self openKMLFileWithSceneControl:sceneControl kmlPath:model.kmlPath];
    objc_setAssociatedObject(sceneControl.scene,
                             SMOpenSceneKey,
                             model,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (isOpen) {
    }
    return isOpen;
}

//  打开本地场景
+ (BOOL)openLocationSceneWithSceneControl:(SceneControl *)sceneControl model:(SceneModel *)model {
    Workspace *workspace = [[Workspace alloc] init];
    WorkspaceConnectionInfo *workspaceInfo = [[WorkspaceConnectionInfo alloc] init];
    sceneControl.scene.workspace = workspace;
    NSString *workspacePath = model.path;
    workspaceInfo.server = workspacePath;
    if ([[workspacePath pathExtension] isEqualToString:@"sxwu"]) {
        workspaceInfo.type = SM_SXWU;
    } else if ([[workspacePath pathExtension] isEqualToString:@"smwu"]) {
        workspaceInfo.type = SM_SMWU;
    }
    
    @try
    {
        BOOL isOpenWorkspaceSucceed = [workspace open:workspaceInfo];
        if (!isOpenWorkspaceSucceed) {
            [Reminder licenseReminder];
            return NO;
        }
        
        if (workspace.scenes.count > 0) {
            NSString *sceneName = [workspace.scenes get:0];
            BOOL isopen = [sceneControl.scene open:sceneName];
            if (isopen) {
            } else {
                NSLog(@"Fail to open scene");
            }
        }
    }
    @catch (NSException *exception)
    {
        NSString *exc = [exception reason];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:exc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    [self openKMLFileWithSceneControl:sceneControl kmlPath:model.kmlPath];
    objc_setAssociatedObject(sceneControl.scene,
                             SMOpenSceneKey,
                             model,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//  打开在线数据
+ (BOOL)openOnlineSceneWithSceneControl:(SceneControl *)sceneControl model:(SceneModel *)model {
    BOOL isOpen = [sceneControl.scene openSceneWithUrl:model.path Name:model.senceName Password:nil];
    NSString *kmlPath = [LocalDownload kmlPathWithModel:model];
    [self openKMLFileWithSceneControl:sceneControl kmlPath:kmlPath];
    model.kmlPath = kmlPath;
    objc_setAssociatedObject(sceneControl.scene,
                             SMOpenSceneKey,
                             model,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (isOpen) {
    }
    return isOpen;
}

//  打开KML文件
+ (void)openKMLFileWithSceneControl:(SceneControl *)sceneControl kmlPath:(NSString *)path {
    BOOL isDirectory;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if (!isExist) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    } else {
        if (isDirectory) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];// 移除同名目录
            [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        }
    }
    if (![sceneControl.scene.layers getLayerWithName:@"Favorite_KML"]) {
        [sceneControl.scene.layers addLayerWith:path Type:KML ToHead:YES LayerName:@"Favorite_KML"];
    }
}

@end
