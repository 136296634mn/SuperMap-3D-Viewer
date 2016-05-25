//
//  Bridge.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/12.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SceneModel, GeoPoint3D, FavoritesSettingModel;
@interface Bridge : NSObject

+ (instancetype)sharedInstance;

@property (copy, nonatomic) void (^zoom)(double ratio);
@property (copy, nonatomic) double (^compass)();
@property (copy, nonatomic) void (^pushToNewViewController)(UIViewController *vc);
@property (copy, nonatomic) void (^popToRootViewController)();
@property (copy, nonatomic) void (^backToHomeMenu)(UIView *view);
@property (copy, nonatomic) void (^showAnalyzeView)();
@property (copy, nonatomic) void (^showFlyView)();
@property (copy, nonatomic) BOOL (^openScene)(SceneModel *model);
@property (copy, nonatomic) void (^layerVisible)(NSString *name, BOOL isOn);
@property (copy, nonatomic) void (^layerSelectable)(NSString *name, BOOL selectable);
@property (copy, nonatomic) void (^addLandmark)(double x, double y, NSString *name);
@property (copy, nonatomic) void (^flyToPoint)(double x, double y);
@property (copy, nonatomic) void (^refreshSearchMenu)();
@property (copy, nonatomic) void (^flyAroundPoint)(GeoPoint3D *point3D, NSInteger speedRatio);
@property (copy, nonatomic) void (^saveFavorites)();
@property (copy, nonatomic) void (^removeFavorites)();
@property (copy, nonatomic) void (^showSearchMenu)();
@property (copy, nonatomic) void (^showRouteMenu)();
@property (copy, nonatomic) void (^addRoute)(NSArray *arr, NSString *origin, NSString *destination);
@property (copy, nonatomic) void (^removeTrackingLayerGeometry)(NSString *tag);
@property (copy, nonatomic) void (^updateFavorite)(FavoritesSettingModel *model, NSIndexPath *indexPath);
@property (copy, nonatomic) void (^removeFeature3D)(NSIndexPath *indexPath);
//@property (copy, nonatomic) void (^updateKMLLayer)();
@property (copy, nonatomic) void (^flyToFeature3D)(NSIndexPath *indexPath);
@property (copy, nonatomic) void (^selectFlyRoute)(NSIndexPath *indexPath);
@property (copy, nonatomic) void (^startFlyRoute)();
@property (copy, nonatomic) void (^pauseFlyRoute)();
@property (copy, nonatomic) void (^stopFlyRoute)();
@property (copy, nonatomic) void (^displayNavigationControl)(BOOL display);
@property (copy, nonatomic) BOOL (^displaySearchAndRouteButton)(BOOL display);
@property (copy, nonatomic) void (^fullScreen)();
@property (copy, nonatomic) void (^showHomeButton)();
@property (copy, nonatomic) void (^showDistanceToolMenu)();
@property (copy, nonatomic) void (^showAreaToolMenu)();
@property (copy, nonatomic) void (^showVisibilityToolMenu)();
@property (copy, nonatomic) void (^clearAnalyzeResult)();
@property (copy, nonatomic) void (^exitAnalyze)();
@property (copy, nonatomic) void (^nextVC)(UIViewController *vc);
@property (copy, nonatomic) void (^deliverIServerSceneSearchResult)(NSArray *items);
@property (copy, nonatomic) void (^dismissSearchView)();
@property (copy, nonatomic) void (^resetSearchView)();
@property (copy, nonatomic) void (^routeViewFetchSearchData)(NSString *text);
@property (copy, nonatomic) void (^routeViewRefreshResultsMenu)();
@property (copy, nonatomic) void (^selectRouteResultsCellEvent)(NSString *text);
@property (copy, nonatomic) void (^visibleRouteViewResultsMenu)(BOOL visible);
@property (copy, nonatomic) void (^visibleRouteViewHistoryMenu)(BOOL visible);
@property (copy, nonatomic) void (^routeViewFetchHistoryData)();
@property (copy, nonatomic) void (^routeViewRefreshHistoryMenu)();
@property (copy, nonatomic) void (^dismissRouteView)();
@property (copy, nonatomic) void (^removeRoute)();
@property (copy, nonatomic) void (^setOriginAndDestination)(NSString *origin, NSString *destination);
@property (copy, nonatomic) void (^handleHomeButtonEvent)();

@end
