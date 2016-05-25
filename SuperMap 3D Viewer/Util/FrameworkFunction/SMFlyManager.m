//
//  SMFlyManager.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/31.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SMFlyManager.h"
#import <SuperMap/SuperMap.h>
#import "SceneModel.h"
#import <objc/runtime.h>
#import "SMOpenScene.h"

@implementation SMFlyManager

+ (void)prepareFlyRoutesWithSceneControl:(SceneControl *)sceneControl
                                     fpf:(NSString *)fpfName
                              completion:(void (^)(id responseObject))completion {
    __block NSString *xmlPath = nil;
    NSString *sceneName = sceneControl.scene.name;
    NSString *sceneURL = sceneControl.scene.url;
    SceneModel *model = (SceneModel *)objc_getAssociatedObject(sceneControl.scene, SMOpenSceneKey);
    SceneModelType type = model.type;
    dispatch_queue_t queue = dispatch_queue_create("FlyFile", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        switch (type) {
            case SceneModelTypeExample:
                xmlPath = [self exampleFpfPathWithFpf:fpfName sceneName:sceneName];
                break;
            case SceneModelTypeLocation:
                xmlPath = [self locationFpfPathWithFpf:fpfName sceneName:sceneName];
                break;
            case SceneModelTypeOnline:
                xmlPath = [self onlineFpfPathWithSceneURL:sceneURL sceneName:sceneName];
                break;
        }
        [sceneControl.scene.flyManager.routes fromFile:xmlPath];
        NSArray *routes = [self flyRoutesWithSceneControl:sceneControl];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(routes);
//            if (routes.count > 0) {
//                
//            }
        });
    });
}

//  范例数据飞行文件路径
+ (NSString *)exampleFpfPathWithFpf:(NSString *)fpfName sceneName:(NSString *)sceneName {
    NSString *xmlPath = nil;
    NSString * bundlePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"UserData.bundle"];
    NSBundle * libBundle = [NSBundle bundleWithPath:bundlePath];
    bundlePath=[libBundle resourcePath];
    if (fpfName != nil) {
        xmlPath = [bundlePath stringByAppendingFormat:@"/Data/%@.fpf",fpfName];
    }else {
        xmlPath = [bundlePath stringByAppendingFormat:@"/Data/%@.fpf",sceneName];
    }
    return xmlPath;
}

//  本地数据飞行文件路径
+ (NSString *)locationFpfPathWithFpf:(NSString *)fpfName sceneName:(NSString *)sceneName {
    NSString *xmlPath = nil;
    NSString *documentDirectory=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    if (fpfName != nil) {
        xmlPath = xmlPath = [documentDirectory stringByAppendingFormat:@"/Data/%@/%@.fpf",sceneName,fpfName];
    }else {
        xmlPath = [documentDirectory stringByAppendingFormat:@"/Data/%@/%@.fpf",sceneName,sceneName];
    }
    return xmlPath;
}

//  在线数据飞行文件路径
+ (NSString *)onlineFpfPathWithSceneURL:(NSString *)sceneURL sceneName:(NSString *)sceneName {
    NSString *prefix = @"http://";
    NSString *suffix = @"/rest/realspace";
    if ([sceneURL hasPrefix:prefix])
    {
        NSRange rangeHTTP = [sceneURL rangeOfString:prefix];
        sceneURL = [sceneURL substringFromIndex:rangeHTTP.length];
    }
    if ([sceneURL hasSuffix:suffix])
    {
        NSRange rangeRest = [sceneURL rangeOfString:suffix];
        sceneURL = [sceneURL substringToIndex:rangeRest.location];
    }
    sceneURL = [sceneURL stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    sceneURL = [sceneURL stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    sceneURL = [sceneURL stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    NSString *xmlPath = [documentDirectory stringByAppendingFormat:@"/SuperMap/Cache/%@/%@.fpf",sceneURL,sceneName];
    return xmlPath;
}

+ (NSArray *)flyRoutesWithSceneControl:(SceneControl *)sceneControl {
    Routes *routes = sceneControl.scene.flyManager.routes;
    NSInteger count = routes.count;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < count; i++) {
        NSString *name =[routes getRouteNameWithIndex:i];
        [items addObject:name];
    }
    return items;
}

@end
