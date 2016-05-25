//
//  LocalDownload.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/15.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "LocalDownload.h"
#import <SuperMap/SuperMap.h>
#import "SceneModel.h"

@implementation LocalDownload

+ (void)GET:(NSString *)URLString success:(Success)success failure:(Failure)failure {
    
}

+ (void)getExampleDataSuccess:(Success)success failure:(Failure)failure {
    NSMutableArray *responseObject = [[NSMutableArray alloc] init];
    NSString *userDataBundle = [[NSBundle mainBundle] pathForResource:@"UserData" ofType:@"bundle"];
    NSString *dataFile = [userDataBundle stringByAppendingPathComponent:@"Contents/Resources/Data"];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExist = [manager fileExistsAtPath:dataFile isDirectory:&isDirectory];
    if (!(isExist && isDirectory)) {//  路径不存在或文件不存在
        NSError *error = [NSError errorWithDomain:@"host.com" code:500 userInfo:nil];
        if (failure) failure(error);
        return;
    }
    NSError *error = nil;
    NSArray *contents = [manager contentsOfDirectoryAtPath:dataFile error:&error];
    if (error) {//  无法读取目录内容
        if (failure) failure(error);
        return;
    }
    [contents enumerateObjectsUsingBlock:^(NSString * _Nonnull fileName, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *fullPath = [dataFile stringByAppendingPathComponent:fileName];
        BOOL isDirectory;
        BOOL isExist = [manager fileExistsAtPath:fullPath isDirectory:&isDirectory];
        if (isExist && isDirectory) {
            NSError *error = nil;
            NSArray *array = [manager contentsOfDirectoryAtPath:fullPath error:&error];
            for (NSInteger i = 0; i < array.count; i++)
            {
                NSString *name = [array objectAtIndex:i];
                NSString *path = [fullPath stringByAppendingPathComponent:name];
                NSError *error = nil;
                NSArray *array = [manager contentsOfDirectoryAtPath:path error:&error];
                for (NSInteger i = 0; i < array.count; i++) {
                    NSString *name = [array objectAtIndex:i];
                    if ([[name pathExtension] isEqualToString:@"xml"])
                    {
                        NSString *sceneName = [name stringByDeletingPathExtension];
                        NSString *temp = nil;
                        if ([sceneName isEqualToString:@"CBD"]) {
                            temp = @"CBD";
                        } else if ([sceneName isEqualToString:@"金山岭"]) {
                            temp = @"jinshanling";
                        } else if ([sceneName isEqualToString:@"珠峰"]) {
                            temp = @"zhufeng";
                        }
                        NSString *scenePath = [NSString stringWithFormat:@"http://192.168.1.111:8090/iserver/services/realspace-%@/rest/realspace", temp];
                        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                        NSString *kmlPath = [documentPath stringByAppendingFormat:@"/%@_favorite.kml", sceneName];
                        NSDictionary *sceneInfoDic = @{@"senceName" : sceneName,
                                                       @"path" : scenePath,
                                                       @"type" : [NSNumber numberWithUnsignedInteger:SceneModelTypeExample],
                                                       @"kmlPath" : kmlPath};
                        [responseObject addObject:sceneInfoDic];
                    }
                }
            }
        }
    }];
    if (success) success(responseObject);
}

+ (void)getLocalDataSuccess:(Success)success failure:(Failure)failure {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *locationDataPath = [documentPath stringByAppendingString:@"/Data/"];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory = true;
    BOOL isExist = [manager fileExistsAtPath:locationDataPath isDirectory:&isDirectory];
    
    if (!isExist) {
        [manager createDirectoryAtPath:locationDataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSArray *contents = [manager contentsOfDirectoryAtPath:locationDataPath error:nil];
    [contents enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL *stop) {
        
        NSString *fullPath = [locationDataPath stringByAppendingPathComponent:fileName];
        BOOL isDirec;
        //若是文件夹
        if ([manager fileExistsAtPath:fullPath isDirectory:&isDirec] && isDirec)
        {
            //若是工作空间
            NSArray *array = [manager contentsOfDirectoryAtPath:fullPath error:nil];
            for (NSInteger i = 0; i < array.count; i++)
            {
                NSString *name = [array objectAtIndex:i];
                if ([[name pathExtension] isEqualToString:@"sxwu"] ||[[name pathExtension] isEqualToString:@"smwu"])
                {
                    NSString *workspaceName = [name stringByDeletingPathExtension];
                    NSString *workspacePath = [fullPath stringByAppendingFormat:@"/%@", name];
                    NSString *kmlPath = [NSString stringWithFormat:@"%@/%@_favorite.kml", fullPath, [name stringByDeletingPathExtension]];
                    NSDictionary *workspaceInfoDic = @{@"senceName" : workspaceName,
                                                       @"path" : workspacePath,
                                                       @"type" : [NSNumber numberWithUnsignedInteger:SceneModelTypeLocation],
                                                       @"kmlPath" : kmlPath};
                    [results addObject:workspaceInfoDic];
                }
            }
        }
        
    }];
    if (success) success(results);
}

+ (void)getOnlineDataSuccess:(Success)success failure:(Failure)failure {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *iServerDataPath = [documentPath  stringByAppendingString:@"/SuperMap/Cache"];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isDirectory = true;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:iServerDataPath isDirectory:&isDirectory];
    if (!isExist)
    {
        [manager createDirectoryAtPath:iServerDataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //获取并遍历Cache文件夹下所有文件名称
    NSArray *array = [manager contentsOfDirectoryAtPath:iServerDataPath error:nil];
    for (NSInteger i = 0; i < array.count; i++)
    {
        NSString *fileName = [array objectAtIndex:i];
        NSString *fullPath = [iServerDataPath stringByAppendingPathComponent:fileName];
        BOOL isDirec;
        //若是文件夹
        if ([manager fileExistsAtPath:fullPath isDirectory:&isDirec] && isDirec)
        {
            NSArray *fileNameComponent = [fileName componentsSeparatedByString:@"_realspace_services_"];
            //若是经iServer下载后的数据
            if ([fileNameComponent count] > 1)
            {
                NSString *sceneName;
                NSString *sceneURL;
                NSString *kmlPath;
                NSString *sceneXMLPath = [fullPath stringByAppendingPathComponent:@"/Scenes"];
                NSFileManager *manager2 = [NSFileManager defaultManager];
                NSArray *array2 = [manager2 contentsOfDirectoryAtPath:sceneXMLPath error:nil];
                //从Scenes文件夹中获取场景名称
                for (NSInteger j = 0; j < array2.count; j++)
                {
                    NSString *name = [array2 objectAtIndex:j];
                    if ([[name pathExtension] isEqualToString:@"xml"])
                    {
                        sceneName = [name stringByDeletingPathExtension];
                        //                            sceneURL = [sceneXMLPath stringByAppendingPathComponent:name];
                        sceneURL = [NSString stringWithFormat:@"http://www.supermapol.com/realspace/services/realspace-%@/rest/realspace", sceneName];
                        kmlPath = [NSString stringWithFormat:@"%@/%@_favorite.kml", fullPath, sceneName];
                    }
                }
                
                //ToDu
                if (sceneName && sceneURL)
                {
                    NSDictionary *workspaceInfoDic = @{@"senceName" : sceneName,
                                                       @"path" : sceneURL,
                                                       @"type" : [NSNumber numberWithUnsignedInteger:SceneModelTypeOnline],
                                                       @"kmlPath" : kmlPath};
                    [results addObject:workspaceInfoDic];
                }
            }
        }
    }
    if (success) success(results);
}

+ (void)getIServerDataWithURL:(NSString *)URLString
                      success:(Success)success
                      failure:(Failure)failure {
    if (!URLString) return;
    
    SceneServicesList *list = [[SceneServicesList alloc] init];
    BOOL isSuccess = [list load:URLString];
    if (!isSuccess) {
        NSError *error = [[NSError alloc] init];
        if (failure) failure(error);
        return;
    }
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < list.count; i++) {
        NSDictionary *workspaceInfoDic = @{@"senceName" : [list sceneItemAt:i],
                                           @"path" : URLString,
                                           @"type" : [NSNumber numberWithUnsignedInteger:SceneModelTypeOnline],
                                           @"kmlPath" : @""};
        [items addObject:workspaceInfoDic];
    }
    if (success) success(items);
}

+ (void)getFavoritesDataSuccess:(Success)success
                        failure:(Failure)failure
                   sceneControl:(SceneControl *)sceneControl {
    Layer3D *layer3D = [sceneControl.scene.layers getLayerWithName:@"Favorite_KML"];
    Feature3Ds *feature3Ds = layer3D.feature3Ds;
    NSArray *items = [feature3Ds allFeature3DObjectsWithOption:Feature3DSearchOptionAllFeatures];
    if (success) success(items);
}

+ (NSString *)kmlPathWithModel:(SceneModel *)model {
    NSString *kmlPath = nil;
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *iServerDataPath = [documentPath  stringByAppendingString:@"/SuperMap/Cache"];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isDirectory = true;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:iServerDataPath isDirectory:&isDirectory];
    if (!isExist)
    {
        [manager createDirectoryAtPath:iServerDataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //获取并遍历Cache文件夹下所有文件名称
    NSArray *array = [manager contentsOfDirectoryAtPath:iServerDataPath error:nil];
    for (NSInteger i = 0; i < array.count; i++)
    {
        NSString *fileName = [array objectAtIndex:i];
        NSString *fullPath = [iServerDataPath stringByAppendingPathComponent:fileName];
        BOOL isDirec;
        //若是文件夹
        if ([manager fileExistsAtPath:fullPath isDirectory:&isDirec] && isDirec)
        {
            NSArray *fileNameComponent = [fileName componentsSeparatedByString:@"_realspace_services_"];
            //若是经iServer下载后的数据
            if ([fileNameComponent count] > 1)
            {
                NSString *sceneName;
                NSString *sceneURL;
                NSString *sceneXMLPath = [fullPath stringByAppendingPathComponent:@"/Scenes"];
                NSFileManager *manager2 = [NSFileManager defaultManager];
                NSArray *array2 = [manager2 contentsOfDirectoryAtPath:sceneXMLPath error:nil];
                //从Scenes文件夹中获取场景名称
                for (NSInteger j = 0; j < array2.count; j++)
                {
                    NSString *name = [array2 objectAtIndex:j];
                    if ([[name pathExtension] isEqualToString:@"xml"])
                    {
                        sceneName = [name stringByDeletingPathExtension];
                        //                            sceneURL = [sceneXMLPath stringByAppendingPathComponent:name];
                        sceneURL = [NSString stringWithFormat:@"http://www.supermapol.com/realspace/services/realspace-%@/rest/realspace", sceneName];
                        kmlPath = [NSString stringWithFormat:@"%@/%@_favorite.kml", fullPath, sceneName];
                        if ([sceneName isEqualToString:model.senceName] && [sceneURL isEqualToString:model.path]) {
                            return kmlPath;
                        }
                    }
                }
            }
        }
    }
    return kmlPath;
}

@end
