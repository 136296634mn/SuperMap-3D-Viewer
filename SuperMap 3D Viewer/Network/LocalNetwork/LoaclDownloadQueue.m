//
//  LoaclDownloadQueue.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/15.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "LoaclDownloadQueue.h"
#import "LocalDownload.h"
#import "SceneModel.h"
#import <SuperMap/SuperMap.h>
#import "FavoritesSettingModel.h"
#import "LayerModel.h"
#import "Supermap.h"
#import "SMFeature3D.h"

@implementation LoaclDownloadQueue

+ (void)downloadSceneData:(void (^)(id items))response {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("downloadSceneData", DISPATCH_QUEUE_CONCURRENT);
    NSMutableArray *exampleModels = [[NSMutableArray alloc] init];
    NSMutableArray *localModels = [[NSMutableArray alloc] init];
    NSMutableArray *onlineModels = [[NSMutableArray alloc] init];
    
    dispatch_group_async(group, queue, ^{
        [LocalDownload getExampleDataSuccess:^(NSArray *responseObject) {
            [responseObject enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull sceneInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                SceneModel *model = [SceneModel modelWithDic:sceneInfo];
                [exampleModels addObject:model];
            }];
        } failure:nil];
    });
    
    dispatch_group_async(group, queue, ^{
        [LocalDownload getLocalDataSuccess:^(NSArray *responseObject) {
            [responseObject enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull sceneInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                SceneModel *model = [SceneModel modelWithDic:sceneInfo];
                [localModels addObject:model];
            }];
        } failure:nil];
    });
    
    dispatch_group_async(group, queue, ^{
        [LocalDownload getOnlineDataSuccess:^(NSArray *responseObject) {
            [responseObject enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull sceneInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                SceneModel *model = [SceneModel modelWithDic:sceneInfo];
                [onlineModels addObject:model];
            }];
        } failure:nil];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSArray *items = @[@{@"本地场景" : localModels},
                           @{@"范例" : exampleModels},
                           @{@"在线" : onlineModels}];
        response(items);
    });
}

+ (void)downloadFavoritesData:(void (^)(id items))response sceneControl:(SceneControl *)sceneControl {
    dispatch_queue_t queue = dispatch_queue_create("downloadFavoritesData", DISPATCH_QUEUE_CONCURRENT);
    NSMutableArray *items = [[NSMutableArray alloc] init];
    dispatch_async(queue, ^{
        [LocalDownload getFavoritesDataSuccess:^(NSArray *responseObject) {
            [responseObject enumerateObjectsUsingBlock:^(Feature3D * _Nonnull feature3D, NSUInteger idx, BOOL * _Nonnull stop) {
                Feature3D *currentFeature3D = [Supermap sharedInstance].smFeature3D.feature3D;
                if (!(currentFeature3D && [currentFeature3D isEqual:feature3D])) {//    正在添加一个地标时这个地标不在管理范围内
                    GeoPlacemark *placeMark = (GeoPlacemark *)feature3D.geometry3D;
                    GeoStyle3D *style3D = placeMark.style3D;
                    NSString *iconName = [style3D.markerFile lastPathComponent];
                    NSDictionary *dic = @{@"name" : feature3D.name,
                                          @"iconName" : iconName,
                                          @"message" : feature3D.description,
                                          @"visible" : [NSNumber numberWithBool:feature3D.visible]};
                    FavoritesSettingModel *model = [FavoritesSettingModel modelWithDic:dic];
                    [items addObject:model];
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                response(items);
            });
        } failure:nil sceneControl:sceneControl];
    });
}

+ (void)downloadLayer3DData:(void (^)(id))response scene:(Scene *)scene {
    dispatch_queue_t queue = dispatch_queue_create("downloadLayer3DData", DISPATCH_QUEUE_CONCURRENT);
    NSMutableArray *items = [[NSMutableArray alloc] init];
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < scene.layers.count; i++) {
            Layer3D *layer3D = [scene.layers getLayerWithIndex:i];
            if (layer3D) {
                NSDictionary *dic = @{@"layerName" : layer3D.name,
                                      @"captionName" : layer3D.captionName,
                                      @"visible" : [NSNumber numberWithBool:layer3D.visible],
                                      @"selectable" : [NSNumber numberWithBool:layer3D.selectable],
                                      @"type" : [NSNumber numberWithUnsignedInteger:LayerModelTypeLayer3D]};
                LayerModel *model = [LayerModel modelWithDic:dic];
                [items addObject:model];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            response(items);
        });
    });
}

+ (void)downloadTerrainLayerData:(void (^)(id items))response scene:(Scene *)scene {
    dispatch_queue_t queue = dispatch_queue_create("downloadTerrainLayerData", DISPATCH_QUEUE_CONCURRENT);
    NSMutableArray *items = [[NSMutableArray alloc] init];
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < scene.terrainLayers.count; i++) {
            TerrainLayer *layer = [scene.terrainLayers getLayerWithIndex:i];
            if (layer) {
                NSDictionary *dic = @{@"layerName" : layer.name,
                                      @"captionName" : layer.captionName,
                                      @"visible" : [NSNumber numberWithBool:layer.visible],
                                      @"selectable" : @0,
                                      @"type" : [NSNumber numberWithUnsignedInteger:LayerModelTypeTerrainLayer]};
                LayerModel *model = [LayerModel modelWithDic:dic];
                [items addObject:model];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            response(items);
        });
    });
}

+ (void)downloadIServerData:(void (^)(id items))response URL:(NSString *)URLString {
    dispatch_queue_t queue = dispatch_queue_create("downloadIServerData", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [LocalDownload getIServerDataWithURL:URLString
                                     success:^(NSArray *responseObject) {
                                         NSMutableArray *items = [[NSMutableArray alloc] init];
                                         [responseObject enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                             SceneModel *model = [SceneModel modelWithDic:dic];
                                             [items addObject:model];
                                         }];
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             if (response) response(items);
                                         });
                                     }
                                     failure:^(NSError *error) {
                                     }];
    });
}

@end
