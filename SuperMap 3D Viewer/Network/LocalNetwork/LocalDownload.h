//
//  LocalDownload.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/15.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Success)(id responseObject);
typedef void (^Failure)(NSError *error);

@class SceneControl, SceneModel;
@interface LocalDownload : NSObject

+ (void)getExampleDataSuccess:(Success)success failure:(Failure)failure;
+ (void)getLocalDataSuccess:(Success)success failure:(Failure)failure;
+ (void)getOnlineDataSuccess:(Success)success failure:(Failure)failure;

+ (void)getIServerDataWithURL:(NSString *)URLString
                      success:(Success)success
                      failure:(Failure)failure;

//  加载本地KML数据
+ (void)getFavoritesDataSuccess:(Success)success failure:(Failure)failure sceneControl:(SceneControl *)sceneControl;

//  根据model获取KML路径
+ (NSString *)kmlPathWithModel:(SceneModel *)model;

@end
