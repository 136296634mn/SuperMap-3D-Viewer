//
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "ViewController.h"
#import <SuperMap/SuperMap.h>
#import "HomeMenu.h"
#import "Animation.h"
#import "HomeButton.h"
#import "Bridge.h"
#import "NavigationControl.h"
#import "AnalyzeMenu.h"
#import "ToolMenu.h"
#import "Supermap.h"
#import "LongPressGestureDelegate.h"
#import "SMFeature3D.h"
#import "SearchView.h"
#import "SearchAndRouteButton.h"
#import "RouteView.h"
#import "LocalDownload.h"
#import "FlyMenu.h"
#import "SMOpenScene.h"
#import "SMFlyManager.h"
#import "FlyCell.h"
#import "TerrainView.h"
#import "TerrianViewController.h"
#import "AttributesViewController.h"
#import "IPhoneAttributeMenu.h"
#import "SceneModel.h"
#import "AttributesPopoverController.h"
#import "Helper.h"

typedef NS_ENUM(NSUInteger, ScreenDisplayMode) {
    ScreenDisplayModeDefault = 0,
    ScreenDisplayModeFull,
};

typedef NS_ENUM(NSUInteger, VisibilityActionType) {
    VisibilityActionTypeNone = 0,
    VisibilityActionTypeAddViewer,//    设置通视观察点
    VisibilityActionTypeAddTarget,//    设置通视目标点
};

@interface ViewController ()<SceneControlTouchDelegate, FlyManagerDelegate, Tracking3DDelegate, UIPopoverControllerDelegate>
{
    SceneControl *_sceneControl;
}

@property (weak, nonatomic) IBOutlet HomeButton *homeButton;
@property (strong, nonatomic) IBOutlet SceneControl *sceneControl;
@property (weak, nonatomic) IBOutlet HomeMenu *homeMenu;
@property (weak, nonatomic) IBOutlet NavigationControl *navigationControl;
@property (weak, nonatomic) IBOutlet AnalyzeMenu *analyzeMenu;
@property (weak, nonatomic) IBOutlet ToolMenu *toolMenu;
@property (weak, nonatomic) IBOutlet SearchView *searchMenu;
@property (weak, nonatomic) IBOutlet SearchAndRouteButton *searchAndRouteButton;
@property (weak, nonatomic) IBOutlet RouteView *routeMenu;
@property (strong, nonatomic) LongPressGestureDelegate *longPressGestureDelegate;
@property (weak, nonatomic) IBOutlet FlyMenu *flyMenu;
@property (strong, nonatomic) NSTimer *flyTimer;
@property (assign, nonatomic) ScreenDisplayMode screenMode;
@property (strong, nonatomic) Sightline *sightline;
@property (assign, nonatomic) VisibilityActionType actionType;
@property (strong, nonatomic) TrackingLayer3D *trackingLayer3D;
@property (assign, nonatomic) BOOL isMove;
@property (strong, nonatomic) AttributesPopoverController *ipadAttributeView;

@end

@implementation ViewController

@synthesize sceneControl = _sceneControl;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_sceneControl initSceneControl:self];
    _sceneControl.sceneControlDelegate = self;
    _sceneControl.action3D = PANSELECT3D;
    _sceneControl.navigationControlVisible = NO;
    _sceneControl.scene.flyManager.flyManagerDelegate = self;
    _sceneControl.tracking3DDelegate = self;
    self.trackingLayer3D = self.sceneControl.scene.trackingLayer3D;
    [self defaultKML];//    空球默认加载KML图层
    [self adjustGlobeSize];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self bridgeEvent];
    
    //  设置导航控制
    [self setupNavigationControl];
    
    //  设置搜索和路线按钮
//    [self setupSearchAndRouteButton];
    
    //  创建手势
    [self setupGestureRecognizer];
    
    //  初始化属性框
    [self setupAttributeView];
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *path = [documentPath  stringByAppendingString:@"/Data/sc_17_0326@IMAGE_pvr/sichuandixing/Terrain/info.sct"];
    TerrainLayer *layer = [_sceneControl.scene.terrainLayers addLayerWithPath:path toHead:YES];
}

- (void)adjustGlobeSize {
    if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height) {
        double altitude;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            altitude = 16000000;
        } else {
            altitude = 23000000;
        }
        Camera camera = self.sceneControl.scene.camera;
        Camera temp = {altitude, camera.latitude, camera.longitude, camera.tilt, camera.heading};
        self.sceneControl.scene.camera = temp;
    }
}

- (void)defaultKML {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *kmlPath = [documentPath stringByAppendingPathComponent:@"default.kml"];
    [SMOpenScene openKMLFileWithSceneControl:self.sceneControl kmlPath:kmlPath];
}

- (void)bridgeEvent {
    //  利用单例在ViewController和View之间传递事件
    [[Bridge sharedInstance] setZoom:^(double ratio) {
//        if (self.sceneControl.scene.camera.altitude > 11100000 && ratio < 0) return;//  控制相机最大高度
        [self.sceneControl.scene zoom:ratio];
    }];//   <--缩放事件
    [[Bridge sharedInstance] setCompass:^double{
        double heading = self.sceneControl.scene.camera.heading;
        return heading;
    }];//   <--获取指南针heading事件
    [[Bridge sharedInstance] setPushToNewViewController:^(UIViewController *vc) {
        if (self.homeMenu.isHidden == NO)
            [Animation applyHideAnimationToHomeMenu:self.homeMenu];
        [self recoverToolMenu];
        [self.navigationController pushViewController:vc animated:YES];
    }];//   <--跳转控制器事件
    [[Bridge sharedInstance] setBackToHomeMenu:^(UIView *view) {
        [Animation displayHomeMenu:self.homeMenu animated:NO];
        view.hidden = YES;
    }];//   <--从分析菜单或图层菜单返回到主菜单
    [[Bridge sharedInstance] setShowAnalyzeView:^{
        [Animation applyHideAnimationToHomeMenu:self.homeMenu];
        self.analyzeMenu.hidden = NO;
    }];//   <--跳转到分析视图
    [[Bridge sharedInstance] setShowFlyView:^{
        if (self.sceneControl.scene.flyManager.status == PLAY) {
            [self.sceneControl.scene.flyManager stop];
        }
        [SMFlyManager prepareFlyRoutesWithSceneControl:_sceneControl
                                                   fpf:nil
                                            completion:^(id responseObject) {
                                                [self.flyMenu reloadData:responseObject];
                                            }];
        [Animation applyHideAnimationToHomeMenu:self.homeMenu];
        self.flyMenu.hidden = NO;
    }];//   <--跳转到飞行视图
    [[Bridge sharedInstance] setOpenScene:^BOOL(SceneModel *model) {
        [self.toolMenu cancelToolMenuEvent];
        [Animation applyCancelAnimationToToolMenu:self.toolMenu];
        self.homeButton.hidden = NO;
        return [SMOpenScene openSceneWithSceneControl:_sceneControl model:model];;
    }];//   <--打开场景
    [[Bridge sharedInstance] setAddLandmark:^(double x, double y, NSString *name) {
        __weak ViewController *vc = self;
        [vc.toolMenu cancelToolMenuEvent];
        [self addLandmarkWithX:x
                             Y:y
                          name:name
                    completion:^{
                        [vc showToolMenuWithType:ToolMenuTypeFavorites text:[NSString stringWithFormat:@"  (%lf, %lf)", x, y]];
                    }];
    }];//   <--跟踪图层添加地标
    [[Bridge sharedInstance] setFlyToPoint:^(double x, double y) {
        [self.sceneControl.scene flyToPoint:{x, y, 2000}];
    }];//   <--飞到点
    [[Bridge sharedInstance] setFlyAroundPoint:^(GeoPoint3D *point3D, NSInteger speedRatio) {
        [self.sceneControl.scene flyCircle:point3D SpeedRatio:speedRatio];
    }];//   <--绕点飞行
    [[Bridge sharedInstance] setSaveFavorites:^{
        [[Supermap sharedInstance] saveFavoritesWithSceneControl:_sceneControl];
    }];//   <--保存兴趣点
    [[Bridge sharedInstance] setRemoveFavorites:^{
        [[Supermap sharedInstance] removeFavoritesWithSceneControl:_sceneControl];
    }];//   <--移除兴趣点
    [[Bridge sharedInstance] setShowSearchMenu:^{
        [Animation applyDisplayAnimationToSearchMenu:self.searchMenu];
        self.searchMenu.shouldBeginEditing = YES;
    }];//   <--弹出搜索菜单
    [[Bridge sharedInstance] setShowRouteMenu:^{
        [Animation applyDisplayAnimationToRouteMenu:self.routeMenu];
    }];//   <--弹出路线搜索菜单
    [[Bridge sharedInstance] setAddRoute:^(NSArray *arr, NSString *origin, NSString *destination) {
        [[Supermap sharedInstance] addRouteWithSceneControl:_sceneControl
                                                     points:arr
                                                     origin:origin
                                                destination:destination
                                                 completion:^(NSInteger index) {
                                                     [Supermap flyToRouteWithSceneControl:_sceneControl index:index];
                                                 }];
    }];//   <--添加搜索路线(包括两端地标并飞行到路线范围)
    [[Bridge sharedInstance] setRemoveTrackingLayerGeometry:^(NSString *tag) {
        [Supermap removeTrackingLayerGeometryWithSceneControl:_sceneControl tag:tag];
    }];//   <--移除跟踪层Geometry
    [[Bridge sharedInstance] setUpdateFavorite:^(FavoritesSettingModel *model, NSIndexPath *indexPath) {
        [Supermap updateFavoriteDataWithSceneControl:_sceneControl
                                               model:model
                                               index:indexPath.row];
    }];//   <--修改兴趣点
    [[Bridge sharedInstance] setRemoveFeature3D:^(NSIndexPath *indexPath) {
        [Supermap removeFavoriteDataWithSceneControl:_sceneControl index:indexPath.row];
    }];//   <--删除本地Feature3D
//    [[Bridge sharedInstance] setUpdateKMLLayer:^{
//        [Supermap updateKMLLayerWithSceneControl:_sceneControl];
//    }];//   <--KML图层刷新
    [[Bridge sharedInstance] setFlyToFeature3D:^(NSIndexPath *indexPath) {
        [Supermap flyToFavoriteWithSceneControl:_sceneControl index:indexPath.row];
    }];//   <--飞到选定的Feature3D
    [[Bridge sharedInstance] setSelectFlyRoute:^(NSIndexPath *indexPath) {
        _flyMenu.hidden = YES;
        _sceneControl.scene.flyManager.routes.currentRouteIndex = indexPath.row;
        NSString *name = [_sceneControl.scene.flyManager.routes getRouteNameWithIndex:indexPath.row];
        [self.toolMenu cancelToolMenuEvent];
        [self showToolMenuWithType:ToolMenuTypeFly text:[NSString stringWithFormat:@" %@", name]];
    }];//   <--选择飞行路线
    [[Bridge sharedInstance] setStartFlyRoute:^{
        [_sceneControl.scene.flyManager play];
        _sceneControl.action3D = PAN3D;
        NSString *name = [_sceneControl.scene.flyManager.routes getRouteNameWithIndex:_sceneControl.scene.flyManager.currentStopIndex];
        if (!self.flyTimer) {
            self.flyTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                             target:self
                                                           selector:@selector(handleFlyTimerEvent:)
                                                           userInfo:name
                                                            repeats:YES];
        }
    }];//   <--开启飞行路线
    [[Bridge sharedInstance] setPauseFlyRoute:^{
        [_sceneControl.scene.flyManager pause];
        self.sceneControl.action3D = PANSELECT3D;
    }];//   <--暂停飞行路线
    [[Bridge sharedInstance] setStopFlyRoute:^{
        if (_sceneControl.scene.flyManager.status != STOP) {
            [_sceneControl.scene.flyManager stop];
            self.sceneControl.action3D = PANSELECT3D;
        }
        if (self.flyTimer) {
            [self.flyTimer invalidate];
            self.flyTimer = nil;
        }
    }];//   <--停止飞行路线
    [[Bridge sharedInstance] setDisplayNavigationControl:^(BOOL display) {
        self.navigationControl.hidden = !display;
    }];//   <--是否显示导航条
    [[Bridge sharedInstance] setDisplaySearchAndRouteButton:^BOOL(BOOL display) {
        if (self.homeMenu.isHidden == NO)
        [Animation applyHideAnimationToHomeMenu:self.homeMenu];
        [self recoverToolMenu];
        if (self.searchAndRouteButton.type == SearchTypeNone) {
            self.searchAndRouteButton.hidden = !display;
            return YES;
        }
        return NO;
    }];//   <--是否显示POI和路径搜索按钮
    [[Bridge sharedInstance] setFullScreen:^{
        [self fullScreen];
        self.screenMode = ScreenDisplayModeFull;
    }];//   <--全屏显示
    [[Bridge sharedInstance] setShowHomeButton:^{
        self.homeButton.hidden = NO;
    }];//   <--显示主按钮
    [[Bridge sharedInstance] setShowDistanceToolMenu:^{
        self.analyzeMenu.hidden = YES;
        [self.toolMenu cancelToolMenuEvent];
        [self showToolMenuWithType:ToolMenuTypeDistance text:@""];
        self.sceneControl.action3D = MEASUREDISTANCE3D;
    }];//   <--显示距离测量工具菜单
    [[Bridge sharedInstance] setShowAreaToolMenu:^{
        self.analyzeMenu.hidden = YES;
        [self.toolMenu cancelToolMenuEvent];
        [self showToolMenuWithType:ToolMenuTypeArea text:@""];
        self.sceneControl.action3D = MEASUREAREA3D;
    }];//   <--显示面积测量工具菜单
    [[Bridge sharedInstance] setShowVisibilityToolMenu:^{
        self.analyzeMenu.hidden = YES;
        [self.toolMenu cancelToolMenuEvent];
        [self showToolMenuWithType:ToolMenuTypeVisibility text:@""];
        self.sceneControl.action3D = CREATEPOINT3D;
        self.actionType = VisibilityActionTypeAddViewer;
        if (!_sightline) {
            _sightline = [[Sightline alloc] initWith:_sceneControl.scene];
        }
    }];//   <--显示通视工具菜单
    [[Bridge sharedInstance] setClearAnalyzeResult:^{
        [self.toolMenu refreshText:@""];
        self.sceneControl.action3D = self.sceneControl.action3D;
        if (_sightline) {
            [self.sightline clearResult];
            self.actionType = VisibilityActionTypeAddViewer;
        }
    }];//   <--清除分析结果
    [[Bridge sharedInstance] setExitAnalyze:^{
        if (_sightline) {
            [self.sightline clearResult];
            self.actionType = VisibilityActionTypeNone;
            self.sightline = nil;
        }
        self.sceneControl.action3D = PANSELECT3D;
    }];//   <--退出分析
    [[Bridge sharedInstance] setNextVC:^(UIViewController *vc) {
        [self.navigationController pushViewController:vc animated:NO];
    }];//   <--跳转到在线数据搜索页面方法
    [[Bridge sharedInstance] setDismissSearchView:^{
        [Animation applyDismissAnimationToSearchMenu:self.searchMenu completion:^{
            [self.searchMenu clearData];
        }];
        [self.searchMenu resignFirstResponder];
        self.searchAndRouteButton.hidden = NO;
        self.searchAndRouteButton.type = SearchTypeNone;
    }];//   <--POI搜索页面消失
    [[Bridge sharedInstance] setDismissRouteView:^{
        [Animation applyDismissAnimationToRouteMenu:self.routeMenu completion:^{
            [self.routeMenu clearData];
        }];
        self.searchAndRouteButton.hidden = NO;
        self.searchAndRouteButton.type = SearchTypeNone;
    }];//   <--路径搜索页面消失
    [[Bridge sharedInstance] setRemoveRoute:^{
        [Supermap removeTrackingLayerGeometryWithSceneControl:self.sceneControl tag:@"Route"];
        [Supermap removeTrackingLayerGeometryWithSceneControl:self.sceneControl tag:@"Landmark"];
    }];//   <--移除路线
    [[Bridge sharedInstance] setHandleHomeButtonEvent:^{
        self.toolMenu.alpha = 0.5;
        self.toolMenu.userInteractionEnabled = NO;
        self.homeButton.hidden = NO;
        [self handleHomeButtonEvent];
    }];//   <--主按钮事件
}

- (void)setupGestureRecognizer {
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureEvent:)];
    longPressGesture.minimumPressDuration = 0.75;
    self.longPressGestureDelegate = [[LongPressGestureDelegate alloc] init];
    longPressGesture.delegate = self.longPressGestureDelegate;
    [self.view addGestureRecognizer:longPressGesture];
}

- (void)showToolMenuWithType:(ToolMenuType)type text:(NSString *)text {
    self.toolMenu.type = type;
    [self.toolMenu refreshText:text];
    [Animation applyShowAnimationToToolMenu:_toolMenu];
    self.homeButton.hidden = YES;
    if (self.homeMenu.isHidden == NO)
    [Animation applyHideAnimationToHomeMenu:self.homeMenu];
    [self recoverToolMenu];
}

- (void)setupNavigationControl {
    [self.navigationControl setNorth:^{
        [_sceneControl.scene stopCameraInteria];    //  停止Camera相机惯性
        Camera camera = _sceneControl.scene.camera;
        Camera newCamera = {camera.altitude, camera.latitude, camera.longitude, camera.tilt, 0};
        _sceneControl.scene.camera = newCamera;
    }];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [userDefaults objectForKey:@"NavigationDisplay"];
    if (number) {
        self.navigationControl.hidden = ![number boolValue];
    } else {
        self.navigationControl.hidden = NO;
    }
}

- (void)setupAttributeView {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self setupIPHONEAttributeView];
    }
}

- (void)setupIPADAttributeView {
    AttributesViewController *vc = [[AttributesViewController alloc] init];
    vc.preferredContentSize = vc.view.bounds.size;
    AttributesPopoverController *ipadAttributeView = [[AttributesPopoverController alloc] initWithContentViewController:vc];
    ipadAttributeView.delegate = self;
    self.ipadAttributeView = ipadAttributeView;
}

- (void)setupIPHONEAttributeView {
    IPhoneAttributeMenu *menu = [IPhoneAttributeMenu sharedInstance];
    [menu makeKeyWindow];
    menu.hidden = NO;
    [menu resignKeyWindow];
    menu.hidden = YES;
}

#pragma mark -- UI

/*
**  主按钮点击事件
*/
- (IBAction)homeButtonClickedEvent:(HomeButton *)sender {
    [self handleHomeButtonEvent];
}

- (void)handleHomeButtonEvent {
    if (!self.analyzeMenu.isHidden) {
        self.analyzeMenu.hidden = YES;
        [self recoverToolMenu];
        return;
    }
    if (!self.flyMenu.isHidden) {
        self.flyMenu.hidden = YES;
        [self recoverToolMenu];
        return;
    }
    if (self.homeMenu.isHidden) {
        [Animation displayHomeMenu:self.homeMenu animated:YES];
        [self.homeMenu adjustContentOffset];
    } else {
        [Animation applyHideAnimationToHomeMenu:self.homeMenu];
        [self recoverToolMenu];
    }
}

/*
 **  地形按钮点击事件
*/
- (IBAction)handleTerrainButtonEvent:(UIButton *)sender {
    TerrianViewController *vc = [[TerrianViewController alloc] init];
    vc.preferredContentSize = vc.view.bounds.size;
    TerrainView *terrain = [[TerrainView alloc] initWithContentViewController:vc];
    [terrain presentPopoverFromRect:sender.bounds
                             inView:sender
           permittedArrowDirections:UIPopoverArrowDirectionAny
                           animated:YES];
}

/*
**  长按手势事件
*/
- (void)handleLongPressGestureEvent:(UILongPressGestureRecognizer *)gesture {
    if (!(self.toolMenu.type == ToolMenuTypeNone || self.toolMenu.type == ToolMenuTypeFavorites)) return;
    CGPoint location = [gesture locationInView:self.view];
    CGFloat scale = [UIScreen mainScreen].scale;
    if (location.x < SMOffSet * SMMarkerScale / scale) return;//    防止修正坐标导致调用pixelToGlobe崩溃
    CGPoint scaleLocation = CGPointMake(location.x * scale - SMOffSet * SMMarkerScale, location.y * scale);//  修正底层添加的点和实际不一致
    Point3D point3D = [_sceneControl.scene pixelToGlobeWith:scaleLocation andPixelToGlobeMode:TerrainAndModel];
    if (gesture.state == UIGestureRecognizerStateBegan && !(point3D.x == 0 && point3D.y == 0 && point3D.z == 0)) {
        __weak ViewController *vc = self;
        [self addFavoriteWithLocation:location completion:^{
            [vc showToolMenuWithType:ToolMenuTypeFavorites text:[NSString stringWithFormat:@"  (%lf, %lf)", point3D.x, point3D.y]];
        }];
    }
}

/*
**  长按添加兴趣点方法
*/
- (void)addFavoriteWithLocation:(CGPoint)location completion:(void(^)())completion {
    UIImageView *favoritesView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
    favoritesView.layer.anchorPoint = location;
    favoritesView.frame = CGRectMake(location.x - 56 / 2, location.y - 56, 56, 56);
    [self.view addSubview:favoritesView];
    if ([Supermap sharedInstance].smFeature3D.feature3D) {
        if ([Supermap sharedInstance].smFeature3D.favorable) {
            [[Supermap sharedInstance] saveFavoritesWithSceneControl:self.sceneControl];
        } else {
            [[Supermap sharedInstance] removeFavoritesWithSceneControl:self.sceneControl];
        }
        [self.toolMenu reloadData];
    }
    [Animation applyAnimationToFavorites:favoritesView completion:^{
        BOOL isSuccess = [[Supermap sharedInstance] addFavoritesWithSceneControl:self.sceneControl location:location];
        if (isSuccess && completion) completion();
    }];
}

/*
 **  POI搜索添加兴趣点方法
 */
- (void)addLandmarkWithX:(double)x
                       Y:(double)y
                    name:(NSString *)name
              completion:(void(^)())completion {
    if ([Supermap sharedInstance].smFeature3D.feature3D) {
        if ([Supermap sharedInstance].smFeature3D.favorable) {
            [[Supermap sharedInstance] saveFavoritesWithSceneControl:self.sceneControl];
        } else {
            [[Supermap sharedInstance] removeFavoritesWithSceneControl:self.sceneControl];
        }
        [self.toolMenu reloadData];
    }
    BOOL isSuccess = [[Supermap sharedInstance] addLandmarkWithSceneControl:self.sceneControl
                                                                    point3D:{x, y, 0}
                                                                       name:name
                                                                       type:SuperMapLandmarkTypeNone];
    if (isSuccess && completion) completion();
}

- (void)handleFlyTimerEvent:(NSTimer *)timer {
    double duration = _sceneControl.scene.flyManager.duration;
    double progress = _sceneControl.scene.flyManager.progress;
    NSString *percent = [NSString stringWithFormat:@" %@:  %.lf%%", timer.userInfo, progress / duration * 100];
    [self.toolMenu refreshText:percent];
}

- (void)fullScreen {
    if (!self.searchAndRouteButton.isHidden) {
        [Animation applyFullScreenAnimationToView:self.searchAndRouteButton];
    }
    if (!self.navigationControl.isHidden) {
        [Animation applyFullScreenAnimationToView:self.navigationControl];
    }
    if (!self.toolMenu.isHidden) {
        [Animation applyFullScreenAnimationToView:self.toolMenu];
    }
}

- (void)exitFullScreen {
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"NavigationDisplay"];
    if (number) {
        if ([number boolValue]) {
            [Animation applyExitFullScreenAnimationToView:self.navigationControl];
        }
    } else {
        [Animation applyExitFullScreenAnimationToView:self.navigationControl];
    }
    if (self.toolMenu.isHidden) {
        [Animation applyExitFullScreenAnimationToView:self.toolMenu];
    }
    if (!visibleSearchAndRouteButton) {
        [Animation applyExitFullScreenAnimationToView:self.searchAndRouteButton];
    }
}

//  距离测量
- (void)handleDistanceWithEvent:(Tracking3DEvent *)event {
    NSString *distance = [NSString stringWithFormat:@" 总距离: %@", [Helper unitConversionWithDistance:event.totalLength]];
    [self.toolMenu refreshText:distance];
}

//  面积测量
- (void)handleAreaWithEvent:(Tracking3DEvent *)event {
    if (event.totalArea <= 0) return;
    
    NSString *area = [NSString stringWithFormat:@" 总面积: %@", [Helper unitConversionWithArea:event.totalArea]];
    [self.toolMenu refreshText:area];
}

//  通视分析
- (void)handleVisibilityWithEvent:(Tracking3DEvent *)event {
    switch (self.actionType) {
        case VisibilityActionTypeNone:
            break;
        case VisibilityActionTypeAddViewer:{
            self.sightline.viewerPosition = event.position;
            self.actionType = VisibilityActionTypeAddTarget;
            [self.sightline build];
        }    break;
        case VisibilityActionTypeAddTarget:
            [self.sightline addTargetPoint:event.position];
            break;
    }
    Point3D point3D = self.sightline.viewerPosition;
    NSString *position = [NSString stringWithFormat:@"(%.2lf, %.2lf, %.2lf)", point3D.x, point3D.y, point3D.z];
    NSInteger count = self.sightline.pointCount;
    NSString *visibility = [NSString stringWithFormat:@" 观察点位置: %@ \n 目标点个数: %ld", position, (long)count];
    [self.toolMenu refreshText:visibility];
}

- (void)showAttributesWithTouches:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.sceneControl];
    [Supermap attributesWithSceneControl:self.sceneControl completion:^(NSArray *items) {
        if (items.count > 0) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [self setupIPADAttributeView];
                AttributesViewController *vc = (AttributesViewController *)self.ipadAttributeView.contentViewController;
                [vc refreshData:items];
                [self.ipadAttributeView presentPopoverFromRect:CGRectMake(point.x, point.y, 20, 20)
                                                        inView:self.sceneControl
                                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                                      animated:NO];
            } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                IPhoneAttributeMenu *menu = [IPhoneAttributeMenu sharedInstance];
                [menu showWithData:items];
                [menu setResignEvent:^{
                    NSInteger count = _sceneControl.scene.layers.count;
                    for (NSInteger i = 0; i < count; i++) {
                        Layer3D *temp = [_sceneControl.scene.layers getLayerWithIndex:i];
                        if ([temp.selection3D count] > 0) {
                            [temp.selection3D clear];
                            break;
                        }
                    }
                }];
            }
        }
    }];
}

//  工具条恢复可操作状态
- (void)recoverToolMenu {
    if (!self.toolMenu.hidden && self.toolMenu.alpha == 0.5) {
        self.toolMenu.alpha = 1.0;
        self.toolMenu.userInteractionEnabled = YES;
        self.homeButton.hidden = YES;
    }
}

#pragma mark -- SceneControlTouchDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self recoverToolMenu];
    if (self.homeMenu.isHidden == NO)
        [Animation applyHideAnimationToHomeMenu:self.homeMenu];
    if (self.analyzeMenu.isHidden == NO)
        self.analyzeMenu.hidden = YES;
    if (self.flyMenu.isHidden == NO)
        self.flyMenu.hidden = YES;
    if (self.searchMenu.isEditing || self.routeMenu.isEditing)
        [self.view endEditing:YES];
    if (self.screenMode == ScreenDisplayModeFull) {
        [self exitFullScreen];
        self.screenMode = ScreenDisplayModeDefault;
    }
    self.isMove = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.isMove = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.isMove) {
//        if (self.sceneControl.scene.flyManager.status == PLAY) {
//            return;
//        }
        [self showAttributesWithTouches:touches];
    }
}

#pragma mark -- FlyManagerDelegate

- (void)statuschanged:(FlyStatus)status {
    if (status == STOP) {
        self.sceneControl.action3D = PANSELECT3D;
        if (self.flyTimer) {
            [self.flyTimer invalidate];
            self.flyTimer = nil;
        }
        if (self.screenMode == ScreenDisplayModeFull) {
            [self exitFullScreen];
            self.screenMode = ScreenDisplayModeDefault;
        }
        NSNotification *noti = [NSNotification notificationWithName:FlyCellChangeImageNotification object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
}

- (void)stopArrivedWithFlyManager:(FlyManager *)flyManager andEvent:(StopArrivedEvent *)event {
}

#pragma mark -- Tracking3DDelegate

- (void)tracking3DEvent:(Tracking3DEvent *)event {
    Action3D action = self.sceneControl.action3D;
    switch (action) {
        case MEASUREDISTANCE3D:
            [self handleDistanceWithEvent:event];
            break;
        case MEASUREAREA3D:
            [self handleAreaWithEvent:event];
            break;
        case CREATEPOINT3D:
            [self handleVisibilityWithEvent:event];
            break;
        default:
            break;
    }
}

#pragma mark -- UIPopoverControllerDelegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    NSInteger count = self.sceneControl.scene.layers.count;
    for (NSInteger i = 0; i < count; i++) {
        Layer3D *temp = [self.sceneControl.scene.layers getLayerWithIndex:i];
        if ([temp.selection3D count] > 0) {
            [temp.selection3D clear];
            break;
        }
    }
    self.ipadAttributeView = nil;
    return YES;
}

#pragma mark -- (UIViewControllerRotation)

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (!self.ipadAttributeView) return;
    
    NSInteger count = self.sceneControl.scene.layers.count;
    for (NSInteger i = 0; i < count; i++) {
        Layer3D *temp = [self.sceneControl.scene.layers getLayerWithIndex:i];
        if ([temp.selection3D count] > 0) {
            [temp.selection3D clear];
            break;
        }
    }
    
    [self.ipadAttributeView dismissPopoverAnimated:YES];
    self.ipadAttributeView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
