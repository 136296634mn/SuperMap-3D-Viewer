//
//  Supermap.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/19.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SuperMap/Point3D.h>

extern const double SMMarkerScale;
extern const double SMOffSet;

typedef NS_ENUM(NSUInteger, SuperMapLandmarkType) {
    SuperMapLandmarkTypeNone = 0,
    SuperMapLandmarkTypeOrigin,
    SuperMapLandmarkTypeDestination,
};

@class SceneControl, SMFeature3D, FavoritesSettingModel;
@interface Supermap : NSObject

@property (strong, nonatomic) SMFeature3D *smFeature3D;

+ (Supermap *)sharedInstance;

//  兴趣点添加时的相关方法
- (BOOL)addFavoritesWithSceneControl:(SceneControl *)sceneControl location:(CGPoint)location;
- (void)removeFavoritesWithSceneControl:(SceneControl *)sceneControl;
- (void)saveFavoritesWithSceneControl:(SceneControl *)sceneControl;

//  兴趣点管理时的相关方法
+ (void)updateFavoriteDataWithSceneControl:(SceneControl *)sceneControl
                                     model:(FavoritesSettingModel *)model
                                     index:(NSInteger)index;
+ (void)removeFavoriteDataWithSceneControl:(SceneControl *)sceneControl index:(NSInteger)index;
+ (void)flyToFavoriteWithSceneControl:(SceneControl *)sceneControl index:(NSInteger)index;

////  刷新KML图层
//+ (void)updateKMLLayerWithSceneControl:(SceneControl *)sceneControl;

//  搜索添加地标
- (BOOL)addLandmarkWithSceneControl:(SceneControl *)sceneControl
                            point3D:(Point3D)point3D
                               name:(NSString *)name
                               type:(SuperMapLandmarkType)type;

//  添加路线、飞到路线范围相关方法
- (void)addRouteWithSceneControl:(SceneControl *)sceneControl
                          points:(NSArray *)points
                          origin:(NSString *)origin
                     destination:(NSString *)destination
                      completion:(void(^)(NSInteger index))completion;
+ (void)flyToRouteWithSceneControl:(SceneControl *)sceneControl index:(NSInteger)index;

//  移除跟踪层Geometry(eg:搜索地标、路线)
+ (void)removeTrackingLayerGeometryWithSceneControl:(SceneControl *)sceneControl tag:(NSString *)tag;

//  获取场景中的Geometry属性
+ (void)attributesWithSceneControl:(SceneControl *)sceneControl completion:(void (^)(id items))completion;

@end
