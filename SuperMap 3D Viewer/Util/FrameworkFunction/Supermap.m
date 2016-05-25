//
//  Supermap.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/19.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "Supermap.h"
#import <SuperMap/SuperMap.h>
#import "SMFeature3D.h"
#import "FavoritesSettingModel.h"
#import "SceneModel.h"
#import <objc/runtime.h>
#import "SMOpenScene.h"
#import "HttpDownload.h"
#import "AttributeModel.h"

const double SMMarkerScale = 1.50;
static const double kMarkerScale = 1.0;
const double SMOffSet = 33.0;

@interface Supermap ()

@end

@implementation Supermap

+ (Supermap *)sharedInstance {
    static Supermap *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[super allocWithZone:NULL] init];
        singleton.smFeature3D = [[SMFeature3D alloc] init];
    });
    return singleton;
}

- (BOOL)addFavoritesWithSceneControl:(SceneControl *)sceneControl location:(CGPoint)location {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGPoint scaleLocation = CGPointMake(location.x * scale - SMOffSet * SMMarkerScale, location.y * scale);//  修正底层添加的点和实际不一致, 33为markerScale为1时对于的偏移量
    Point3D point3D = [sceneControl.scene pixelToGlobeWith:scaleLocation andPixelToGlobeMode:TerrainAndModel];
    GeoPoint3D *geoPoint3D = [[GeoPoint3D alloc] initWithPoint3D:point3D];
    GeoStyle3D *style3D = [[GeoStyle3D alloc] init];
    style3D.markerScale = SMMarkerScale;
    style3D.altitudeMode = Absolute3D;
    NSString *supermapBundle = [[NSBundle mainBundle] pathForResource:@"SuperMap" ofType:@"bundle"];
    NSString *picturePath = [supermapBundle stringByAppendingPathComponent:@"Contents/Resources/Resource/blupin.png"];
    style3D.markerFile = picturePath;
    geoPoint3D.style3D = style3D;
    
    SceneModel *model = objc_getAssociatedObject(sceneControl.scene, SMOpenSceneKey);
    if (![sceneControl.scene.layers getLayerWithName:@"Favorite_KML"]) {
        [sceneControl.scene.layers addLayerWith:model.kmlPath Type:KML ToHead:YES LayerName:@"Favorite_KML"];
    }
    
    Layer3D *layer3D = [sceneControl.scene.layers getLayerWithName:@"Favorite_KML"];
    Feature3Ds *feature3Ds = layer3D.feature3Ds;
    feature3Ds.name = @"feature3Ds";
    Feature3D *feature3D = [[Feature3D alloc] init];
    
    GeoPlacemark *placemark = [[GeoPlacemark alloc] initWithName:@"UntitledFeature3D" andGeomentry:geoPoint3D];
    TextStyle *textStyle = [[TextStyle alloc] init];
//    [textStyle setFontName:@"雅黑"];
    [textStyle setFontHeight:15];//9
    [textStyle setFontWidth:30];//25
    [textStyle setForeColor:[[Color alloc] initWithR:255 G:255 B:255]];
    [textStyle setBackColor:[[Color alloc] initWithR:0 G:0 B:0]];
    [textStyle setAlignment:TA_TOPLEFT];
    placemark.nameStyle = textStyle;
    feature3D.geometry3D = placemark;
    feature3D.description = [NSString stringWithFormat:@"(%lf, %lf)", geoPoint3D.x, geoPoint3D.y];
    feature3D.camera = sceneControl.scene.camera;
    self.smFeature3D.feature3D = [feature3Ds addFeature3D:feature3D];
    BOOL isSuccess = NO;
    if (self.smFeature3D.feature3D) {
        isSuccess = YES;
    }
    return isSuccess;
}

- (void)removeFavoritesWithSceneControl:(SceneControl *)sceneControl {
    Layer3D *layer3D = [sceneControl.scene.layers getLayerWithName:@"Favorite_KML"];
    Feature3Ds *feature3Ds = layer3D.feature3Ds;
    [feature3Ds removeFeature3D:self.smFeature3D.feature3D];
    self.smFeature3D.feature3D = nil;
    self.smFeature3D.favorable = NO;
}

- (void)saveFavoritesWithSceneControl:(SceneControl *)sceneControl {
    SceneModel *model = objc_getAssociatedObject(sceneControl.scene, SMOpenSceneKey);
    Layer3D *layer3D = [sceneControl.scene.layers getLayerWithName:@"Favorite_KML"];
    Feature3Ds *feature3Ds = layer3D.feature3Ds;
    if (model) {
        [feature3Ds toKMLFile:model.kmlPath];
    } else {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *kmlPath = [documentPath stringByAppendingPathComponent:@"default.kml"];
        [feature3Ds toKMLFile:kmlPath];
    }
    self.smFeature3D.feature3D = nil;
    self.smFeature3D.favorable = NO;
}

+ (void)updateFavoriteDataWithSceneControl:(SceneControl *)sceneControl
                                     model:(FavoritesSettingModel *)model
                                     index:(NSInteger)index {
    SceneModel *sceneModel = objc_getAssociatedObject(sceneControl.scene, SMOpenSceneKey);
    Layer3D *layer3D = [sceneControl.scene.layers getLayerWithName:@"Favorite_KML"];
    Feature3Ds *feature3Ds = layer3D.feature3Ds;
//    Feature3D *feature = [feature3Ds feature3DWithID:index + 1 option:Feature3DSearchOptionAllFeatures];//  ID从1开始计数
    NSArray *items = [feature3Ds allFeature3DObjectsWithOption:Feature3DSearchOptionAllFeatures];
    Feature3D *feature = items[index];
    feature.name = model.name;
    feature.description = model.message;
    feature.visible = model.visible;
    GeoPlacemark *placemark = (GeoPlacemark *)feature.geometry3D;
    GeoStyle3D *style3D = placemark.style3D;
//    style3D.markerFile = model.iconPath;
    NSString *supermapBundle = [[NSBundle mainBundle] pathForResource:@"SuperMap" ofType:@"bundle"];
    NSString *commonPath = [supermapBundle stringByAppendingPathComponent:@"Contents/Resources/Resource"];
    style3D.markerFile = [commonPath stringByAppendingPathComponent:model.iconName];
    feature.geometry3D = placemark;
    if (sceneModel) {
        [feature3Ds toKMLFile:sceneModel.kmlPath];
    } else {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *kmlPath = [documentPath stringByAppendingPathComponent:@"default.kml"];
        [feature3Ds toKMLFile:kmlPath];
    }
    [feature updateData];
}

+ (void)removeFavoriteDataWithSceneControl:(SceneControl *)sceneControl index:(NSInteger)index {
    SceneModel *model = objc_getAssociatedObject(sceneControl.scene, SMOpenSceneKey);
    Layer3D *layer3D = [sceneControl.scene.layers getLayerWithName:@"Favorite_KML"];
    Feature3Ds *feature3Ds = layer3D.feature3Ds;
    [feature3Ds removeObjectAtIndex:index];//   index从0开始，不是指ID
    if (model) {
        [feature3Ds toKMLFile:model.kmlPath];
    } else {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *kmlPath = [documentPath stringByAppendingPathComponent:@"default.kml"];
        [feature3Ds toKMLFile:kmlPath];
    }
    [layer3D updateData];
}

+ (void)flyToFavoriteWithSceneControl:(SceneControl *)sceneControl index:(NSInteger)index {
    Layer3D *layer3D = [sceneControl.scene.layers getLayerWithName:@"Favorite_KML"];
    Feature3Ds *feature3Ds = layer3D.feature3Ds;
    NSArray *arr = [feature3Ds allFeature3DObjectsWithOption:Feature3DSearchOptionAllFeatures];
    Feature3D *feature3D = (Feature3D *)arr[index];
//    GeoPlacemark *placemark = (GeoPlacemark *)feature3D.geometry3D;
//    GeoPoint3D *geoPoint3D = (GeoPoint3D *)placemark.geometry;
//    Point3D point3D = {geoPoint3D.x, geoPoint3D.y, geoPoint3D.z + 100};
//    [sceneControl.scene flyToPoint:point3D];
    [sceneControl.scene flyToCamera:feature3D.camera];
}

//+ (void)updateKMLLayerWithSceneControl:(SceneControl *)sceneControl {
//    Layer3D *layer3D = [sceneControl.scene.layers getLayerWithName:@"Favorite_KML"];
//    [layer3D updateData];
//}

- (BOOL)addLandmarkWithSceneControl:(SceneControl *)sceneControl
                            point3D:(Point3D)point3D
                               name:(NSString *)name
                               type:(SuperMapLandmarkType)type {
    BOOL hasExist = [self landmarkExistsWithSceneControl:sceneControl point3D:point3D];
    if (hasExist) return NO;// 如果地标已经存在不在添加
    
    GeoPoint3D *geoPoint3D = [[GeoPoint3D alloc] initWithPoint3D:point3D];
    GeoStyle3D *style3D = [[GeoStyle3D alloc] init];
    style3D.markerScale = [self markerScaleWithType:type];
    style3D.altitudeMode = Absolute3D;
    NSString *picturePath = [self picturePathWithType:type];
    style3D.markerFile = picturePath;
    geoPoint3D.style3D = style3D;
    
    SceneModel *model = objc_getAssociatedObject(sceneControl.scene, SMOpenSceneKey);
    if (![sceneControl.scene.layers getLayerWithName:@"Favorite_KML"]) {
        [sceneControl.scene.layers addLayerWith:model.kmlPath Type:KML ToHead:YES LayerName:@"Favorite_KML"];
    }
    
    Layer3D *layer3D = [sceneControl.scene.layers getLayerWithName:@"Favorite_KML"];
    Feature3Ds *feature3Ds = layer3D.feature3Ds;
    feature3Ds.name = @"feature3Ds";
    Feature3D *feature3D = [[Feature3D alloc] init];
    
    GeoPlacemark *placemark = [[GeoPlacemark alloc] initWithName:name andGeomentry:geoPoint3D];
    TextStyle *textStyle = [[TextStyle alloc] init];
    [textStyle setFontHeight:15];
    [textStyle setFontWidth:30];
    [textStyle setForeColor:[[Color alloc] initWithR:0 G:255 B:0]];
    [textStyle setAlignment:TA_TOPLEFT];
    placemark.nameStyle = textStyle;
    feature3D.geometry3D = placemark;
    feature3D.name = name;
    feature3D.description = [NSString stringWithFormat:@"(%lf, %lf)", geoPoint3D.x, geoPoint3D.y];
    Camera camera = {geoPoint3D.z + 100, geoPoint3D.y, geoPoint3D.x, 0, 0};
    feature3D.camera = camera;
    self.smFeature3D.feature3D = [feature3Ds addFeature3D:feature3D];
    BOOL isSuccess = NO;
    if (self.smFeature3D.feature3D) {
        isSuccess = YES;
    }
    return isSuccess;
}

- (void)addSiteWithSceneControl:(SceneControl *)sceneControl
                        point3D:(Point3D)point3D
                           name:(NSString *)name
                           type:(SuperMapLandmarkType)type {
    BOOL hasExist = [self siteExistsWithSceneControl:sceneControl point3D:point3D];
    if (hasExist) return;// 如果地标已经存在不在添加
    
    GeoPoint3D *geoPoint3D = [[GeoPoint3D alloc] initWithPoint3D:point3D];
    GeoStyle3D *style3D = [[GeoStyle3D alloc] init];
    style3D.markerScale = [self markerScaleWithType:type];
    style3D.altitudeMode = Absolute3D;
    NSString *picturePath = [self picturePathWithType:type];
    style3D.markerFile = picturePath;
    geoPoint3D.style3D = style3D;
    
    GeoPlacemark *placemark = [[GeoPlacemark alloc] initWithName:name andGeomentry:geoPoint3D];
    
    TextStyle *textStyle = [[TextStyle alloc] init];
    [textStyle setFontHeight:9];
    [textStyle setFontWidth:25];
    [textStyle setForeColor:[[Color alloc] initWithR:0 G:255 B:0]];
    [textStyle setAlignment:TA_TOPLEFT];
    placemark.nameStyle = textStyle;
    [sceneControl.scene.trackingLayer3D AddGeometry:placemark Tag:@"Landmark"];
}

- (void)addRouteWithSceneControl:(SceneControl *)sceneControl
                          points:(NSArray *)points
                          origin:(NSString *)origin
                     destination:(NSString *)destination
                      completion:(void(^)(NSInteger index))completion {
    NSMutableArray *point3DsArray = [[NSMutableArray alloc] init];
    [points enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *x = [dic objectForKey:@"x"];
        NSNumber *y = [dic objectForKey:@"y"];
        Point3D point3D = {[x doubleValue], [y doubleValue], 5};
        NSValue *point3DValue = [NSValue value:&point3D withObjCType:@encode(Point3D)];
        [point3DsArray addObject:point3DValue];
    }];
    Point3Ds *point3Ds = [[Point3Ds alloc] initWithPoint3DArray:point3DsArray];
    GeoLine3D *line3D = [[GeoLine3D alloc] initWithPoint3Ds:point3Ds];
    GeoStyle3D *style3D = [[GeoStyle3D alloc] init];
    [style3D setLineWidth:3];
    [style3D setLineColor:[[Color alloc] initWithR:0 G:0 B:255]];
    [style3D setAltitudeMode:Absolute3D];
    [line3D setStyle3D:style3D];
    NSInteger index = [sceneControl.scene.trackingLayer3D AddGeometry:line3D Tag:@"Route"];
    
    NSNumber *originNumberX = ((NSDictionary *)points[0])[@"x"];
    NSNumber *originNumberY = ((NSDictionary *)points[0])[@"y"];
    Point3D originPoint3D = {[originNumberX doubleValue], [originNumberY doubleValue], 0};
    [self addSiteWithSceneControl:sceneControl
                          point3D:originPoint3D
                             name:origin
                             type:SuperMapLandmarkTypeOrigin];
    
    NSNumber *destinationNumberX = ((NSDictionary *)[points lastObject])[@"x"];
    NSNumber *destinationNumberY = ((NSDictionary *)[points lastObject])[@"y"];
    Point3D destinationPoint3D = {[destinationNumberX doubleValue], [destinationNumberY doubleValue], 0};
    [self addSiteWithSceneControl:sceneControl
                          point3D:destinationPoint3D
                             name:destination
                             type:SuperMapLandmarkTypeDestination];
    
    if (completion) completion(index);
}

+ (void)flyToRouteWithSceneControl:(SceneControl *)sceneControl index:(NSInteger)index {
    Geometry *routeGeometry = [sceneControl.scene.trackingLayer3D getWithIndex:index];
    Rectangle2D *rectangle2D = [routeGeometry getBounds];
    Rect2D *rect2D = [[Rect2D alloc] initWithLeft:rectangle2D.left
                                           Bottom:rectangle2D.bottom
                                            Right:rectangle2D.right
                                              Top:rectangle2D.top];
    [sceneControl.scene flyToBounds:rect2D];
}

+ (void)removeTrackingLayerGeometryWithSceneControl:(SceneControl *)sceneControl tag:(NSString *)tag {
    NSInteger count = sceneControl.scene.trackingLayer3D.count;
    NSInteger flag = 0;//   标记删除个数
    for (NSInteger i = 0; i < count; i++) {
        NSInteger j = i - flag;
        NSString *tempTag = [sceneControl.scene.trackingLayer3D getTagWithIndex:j];
        if ([tempTag isEqualToString:tag]) {
            BOOL isSuccess = [sceneControl.scene.trackingLayer3D removeWithIndex:j];
            if (isSuccess) flag++;
        }
    }
}

- (BOOL)siteExistsWithSceneControl:(SceneControl *)sceneControl point3D:(Point3D)point3D {
    NSInteger count = sceneControl.scene.trackingLayer3D.count;
    for (NSInteger i = 0; i < count; i++) {
        Geometry *geometry = [sceneControl.scene.trackingLayer3D getWithIndex:i];
        if (![geometry isKindOfClass:[GeoPoint3D class]]) {
            continue;
        }
        GeoPoint3D *geoPoint3D = (GeoPoint3D *)geometry;
        if (geoPoint3D.x == point3D.x && geoPoint3D.y == point3D.y && geoPoint3D.z == point3D.z) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)landmarkExistsWithSceneControl:(SceneControl *)sceneControl point3D:(Point3D)point3D {
    Layer3D *layer3D = [sceneControl.scene.layers getLayerWithName:@"Favorite_KML"];
    Feature3Ds *feature3Ds = layer3D.feature3Ds;
    NSArray *items = [feature3Ds allFeature3DObjectsWithOption:Feature3DSearchOptionAllFeatures];
    __block BOOL hasExist = NO;
    [items enumerateObjectsUsingBlock:^(Feature3D * _Nonnull feature3D, NSUInteger idx, BOOL * _Nonnull stop) {
        GeoPlacemark *placemark = (GeoPlacemark *)feature3D.geometry3D;
        GeoPoint3D *geoPoint3D = (GeoPoint3D *)placemark.geometry;
        if (geoPoint3D.x == point3D.x && geoPoint3D.y == point3D.y && geoPoint3D.z == point3D.z) {
            hasExist = YES;
            *stop = YES;
        }
    }];
    return hasExist;
}

- (NSString *)picturePathWithType:(SuperMapLandmarkType)type {
    NSString *supermapBundle = [[NSBundle mainBundle] pathForResource:@"SuperMap" ofType:@"bundle"];
    NSString *picturePath = nil;
    switch (type) {
        case SuperMapLandmarkTypeNone:
            picturePath = [supermapBundle stringByAppendingPathComponent:@"Contents/Resources/Resource/blupin.png"];
            break;
        case SuperMapLandmarkTypeOrigin:
            picturePath = [supermapBundle stringByAppendingPathComponent:@"Contents/Resources/Resource/起点.png"];
            break;
        case SuperMapLandmarkTypeDestination:
            picturePath = [supermapBundle stringByAppendingPathComponent:@"Contents/Resources/Resource/终点.png"];
            break;
    }
    return picturePath;
}

- (double)markerScaleWithType:(SuperMapLandmarkType)type {
    double markScale;
    switch (type) {
        case SuperMapLandmarkTypeNone:
            markScale = SMMarkerScale;
            break;
        case SuperMapLandmarkTypeOrigin:
        case SuperMapLandmarkTypeDestination:
            markScale = kMarkerScale;
            break;
    }
    return markScale;
}

+ (void)attributesWithSceneControl:(SceneControl *)sceneControl completion:(void (^)(id items))completion {
    NSArray *items = nil;
    Layer3D *layer3D = [self layer3DWithSceneControl:sceneControl];//   获取选中图层
    if (!layer3D) {
        if (completion) completion(items);
        return;
    };
    
    SceneModel *model = objc_getAssociatedObject(sceneControl.scene, SMOpenSceneKey);
    if (layer3D.type == KML) {
        items = [self kmlAttributesWithLayer3D:layer3D];
        if (completion) completion(items);
        return;
    }
    
    FieldInfos *fieldInfos = layer3D.fieldInfos;
    NSInteger count = [fieldInfos count];
    if (count > 0) {
        items = [self fieldInfosAttributesWithLayer3D:layer3D];
        if (completion) completion(items);
        return;
    }
    
    if (model.type == SceneModelTypeOnline) {
        [self onlineAttributesWithModel:model
                                layer3D:layer3D
                                success:^(id items) {
                                    if (completion) completion(items);
                                    return;
                                }
                                failure:^(HttpDownloadErrorType errorType) {
                                    if (completion) completion(items);
                                    return;
                                }];
    }
    
    items = [self datasourcesAttributesWithSceneControl:sceneControl];
    if (completion) completion(items);
    return;
}

+ (Layer3D *)layer3DWithSceneControl:(SceneControl *)sceneControl {
    Layer3D *layer3D = nil;
    NSInteger count = sceneControl.scene.layers.count;
    for (NSInteger i = 0; i < count; i++) {
        Layer3D *temp = [sceneControl.scene.layers getLayerWithIndex:i];
        if ([temp.selection3D count] > 0) {
            layer3D = temp;
        }
    }
    return layer3D;
}

+ (void)onlineAttributesWithModel:(SceneModel *)model
                          layer3D:(Layer3D *)layer3D
                          success:(void (^)(id items))success
                          failure:(void (^)(HttpDownloadErrorType errorType))failure {
    Selection3D *selection = layer3D.selection3D;
    int selectionID = [selection getIDWithIndex:0];
    NSString *sceneName = model.senceName;
    NSString *sceneURL = model.path;
    NSRange nameRange = [sceneURL rangeOfString:sceneName options:NSBackwardsSearch];
    NSString *str = [sceneURL substringToIndex:nameRange.location];
    NSRange range = [str rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *prefix = [str substringToIndex:range.location];
    NSString *path = [NSString stringWithFormat:@"%@/data-%@/rest/data/datasources/name/%@/datasets/name/%@/features/%d.json?hasGeometry=false", prefix, sceneName, sceneName, sceneName, selectionID];
    [HttpDownload downloadAttributeDataWithURL:path
                                       success:^(id items) {
                                           if (success) success(items);
                                       }
                                       failure:^(HttpDownloadErrorType errorType) {
                                       }];
}

+ (NSArray *)kmlAttributesWithLayer3D:(Layer3D *)layer3D {
    NSInteger ID = [layer3D.selection3D getIDWithIndex:0];
    Feature3Ds *feature3Ds = layer3D.feature3Ds;
    Feature3D *feature3D = [feature3Ds feature3DWithID:ID option:Feature3DSearchOptionAllFeatures];
    NSMutableArray *models = [[NSMutableArray alloc] init];
    NSDictionary *attributes = @{@"Name" : feature3D.name,
                          @"Description" : feature3D.description};
    NSArray *keys = [attributes allKeys];
    [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = @{@"key" : obj,
                              @"value" : [attributes objectForKey:obj]};
        AttributeModel *model = [AttributeModel modelWithDic:dic];
        [models addObject:model];
    }];
    return models;
}

+ (NSArray *)fieldInfosAttributesWithLayer3D:(Layer3D *)layer3D {
    FieldInfos *fieldInfos = layer3D.fieldInfos;
    NSInteger count = [fieldInfos count];
    Feature3D *feature3D = [layer3D.selection3D toFeature3D];
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < count; i++) {
        if ([[fieldInfos get:i].name hasPrefix:@"SM"] || [[fieldInfos get:i].name hasPrefix:@"Sm"]) {
            continue;
        }
        FieldType type = [fieldInfos get:i].fieldType;
        id fieldValue = [feature3D getFieldValueWithIndex:i];
        if (!fieldValue) {
            fieldValue = @"";
        }
        NSDictionary *dic = nil;
        switch (type) {
            case FT_INT32:
            case FT_INT16: {
                NSString *key = [fieldInfos get:i].name;
                NSString *value = [NSString stringWithFormat:@"%d", [(NSNumber *)fieldValue intValue]];
                dic = @{@"key" : key,
                        @"value" : value};
            }    break;
            case FT_DOUBLE:
            case FT_SINGLE: {
                NSString *key = [fieldInfos get:i].name;
                NSString *value = [NSString stringWithFormat:@"%f", [(NSNumber *)fieldValue doubleValue]];
                dic = @{@"key" : key,
                        @"value" : value};
            }    break;
            case FT_TEXT: {
                NSString *key = [fieldInfos get:i].name;
                NSString *value = [NSString stringWithFormat:@"%@", fieldValue];
                dic = @{@"key" : key,
                        @"value" : value};
            }    break;
            default:
                break;
        }
        AttributeModel *model = [AttributeModel modelWithDic:dic];
        [models addObject:model];
    }
    return models;
}

+ (NSArray *)datasourcesAttributesWithSceneControl:(SceneControl *)sceneControl {
    Datasources *datasources = sceneControl.scene.workspace.datasources;
    if (datasources.count < 1) return nil;
    
    Datasource *datasource = [datasources getAlias:@"vector"];//ToDo:
    if (!datasource) return nil;
    
    DatasetVector *datasetVector = (DatasetVector *)[datasource.datasets getWithName:@"房屋面"];//ToDo:
    if (!datasetVector) return nil;
    
    NSString *strFilter = [NSString stringWithFormat:@"SmID = %d", 69];
    QueryParameter *parameter = [[QueryParameter alloc] init];
    parameter.attriButeFilter = strFilter;
    parameter.cursorType = STATIC;
    Recordset *recordset = [datasetVector query:parameter];
    
    if (recordset.fieldCount < 1) return nil;
    
    FieldInfos *fieldInfos = datasetVector.fieldInfos;
    [recordset moveFirst];
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < fieldInfos.count; i++) {
        NSString *name = [fieldInfos get:i].name;
        if ([name hasPrefix:@"SM"] || [name hasPrefix:@"Sm"]) {
            continue;
        }
        id fieldValue = [recordset getFieldValueWithString:name];
        if (!fieldValue) {
            fieldValue = @"";
        }
        FieldType type = [fieldInfos get:i].fieldType;
        NSDictionary *dic = nil;
        switch (type) {
            case FT_INT32:
            case FT_INT16: {
                NSString *value = [NSString stringWithFormat:@"%d", [(NSNumber *)fieldValue intValue]];
                dic = @{@"key" : name,
                        @"value" : value};
            }    break;
            case FT_DOUBLE:
            case FT_SINGLE: {
                NSString *value = [NSString stringWithFormat:@"%f", [(NSNumber *)fieldValue doubleValue]];
                dic = @{@"key" : name,
                        @"value" : value};
            }    break;
            case FT_TEXT: {
                NSString *value = [NSString stringWithFormat:@"%@", fieldValue];
                dic = @{@"key" : name,
                        @"value" : value};
            }    break;
            default:
                break;
        }
        AttributeModel *model = [AttributeModel modelWithDic:dic];
        [models addObject:model];
    }
    [recordset dispose];
    return models;
}

@end
