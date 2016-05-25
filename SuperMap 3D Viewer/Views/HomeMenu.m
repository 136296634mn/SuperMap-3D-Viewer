//
//  HomeMenu.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/11.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "HomeMenu.h"
#import "Helper.h"
#import "HomeMenuTableViewCell.h"
#import "SceneViewController.h"
#import "Bridge.h"
#import "SettingViewController.h"
#import "FavoritesViewController.h"
#import "LayerViewController.h"
#import <SuperMap/SuperMap.h>
#import "AdaptiveFit.h"

#define HOMEMENU_CELL_HEIGHT 60 //主菜单cell高度

BOOL visibleSearchAndRouteButton = YES;

typedef NS_ENUM(NSUInteger, HomeMenuItemType) {
    HomeMenuItemTypeScene = 0,
    HomeMenuItemTypeLayer,
    HomeMenuItemTypeAnalyze,
    HomeMenuItemTypeFly,
    HomeMenuItemTypeFavorites,
    HomeMenuItemTypeSearchPosition,
    HomeMenuItemTypeAbout,
};

@interface HomeMenu ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UITableView *homeMenu;
@property (strong, nonatomic) UIImageView *tailImageView;
@property (strong, nonatomic) UIView *leftLine;
@property (strong, nonatomic) UIView *rightLine;
@property (copy, nonatomic) NSArray *items;
@property (copy, nonatomic) NSArray *images;

@end

@implementation HomeMenu

- (void)awakeFromNib {
    [self initialize];
    [self layout];
}

- (void)initialize {
    [self initializeDataSource];
    [self initializeUI];
}

//  初始化数据源
- (void)initializeDataSource {
    self.items = @[@"场景", @"图层", @"分析", @"飞行", @"兴趣点", @"位置搜索", @"关于"];
    self.images = @[@"places@2x.png", @"layers@2x.png", @"analyze@2x.png", @"fly@2x.png", @"favorites@2x.png", @"icon_网络分析.png", @"about@2x.png"];
}

//  初始化UI控件
- (void)initializeUI {
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.image = [UIImage imageNamed:@"mm_top@2x.png"];
    [self addSubview:headerImageView];
    self.headerImageView = headerImageView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = GetColor(24.0, 24.0, 24.0, 0.85);
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:tableView];
    self.homeMenu = tableView;
    [self addSeparatorToTableView];
    
    UIImageView *tailImageView = [[UIImageView alloc] init];
    tailImageView.image = [UIImage imageNamed:@"mm_bottom@2x.png"];
    [self addSubview:tailImageView];
    self.tailImageView = tailImageView;
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:leftLine];
    self.leftLine = leftLine;
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:rightLine];
    self.rightLine = rightLine;
    
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeWidth) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                constraint.constant = [AdaptiveFit sizeFromIPone6P:240];
            } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                constraint.constant = 240;
            }
        }
    }
}

//  自定义UITableView分割线
- (void)addSeparatorToTableView {
    for (NSInteger i = 0; i < _items.count - 1; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (i + 1)*HOMEMENU_CELL_HEIGHT, 240, 1)];
        view.backgroundColor = [UIColor lightGrayColor];
        [self.homeMenu addSubview:view];
    }
}

//  布局控件
- (void)layout {
    //  顶部UIImageView布局
    self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_headerImageView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_headerImageView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_headerImageView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0]]];
    [self.headerImageView addConstraints:@[[NSLayoutConstraint constraintWithItem:_headerImageView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:50]]];
    
    //  左侧白线布局
    self.leftLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_leftLine
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_homeMenu
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_leftLine
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_leftLine
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_homeMenu
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0]]];
    [self.leftLine addConstraint:[NSLayoutConstraint constraintWithItem:_leftLine
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0f
                                                               constant:2]];
    
    //  主UITableView布局
    self.homeMenu.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_homeMenu
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_headerImageView
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_homeMenu
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_leftLine
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_homeMenu
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_rightLine
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_homeMenu
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_tailImageView
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0]]];
    
    //  右侧白线布局
    self.rightLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_rightLine
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_homeMenu
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_rightLine
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_homeMenu
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_rightLine
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0]]];
    [self.rightLine addConstraint:[NSLayoutConstraint constraintWithItem:_rightLine
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0f
                                                                constant:2]];
    
    //  底部UIImageView布局
    self.tailImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_tailImageView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_tailImageView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_tailImageView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0]]];
    [self.tailImageView addConstraint:[NSLayoutConstraint constraintWithItem:_tailImageView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f
                                                                    constant:30]];
}

//  跳转到对应的页面
- (void)pushWithIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case HomeMenuItemTypeScene: {
            [self pushToSceneViewController];
        }    break;
        case HomeMenuItemTypeLayer: {
            [self pushToLayerViewController];
        }    break;
        case HomeMenuItemTypeAnalyze: {
            [self showAnalyzeView];
        }    break;
        case HomeMenuItemTypeFly: {
            [self showFlyView];
        }    break;
        case HomeMenuItemTypeFavorites: {
            [self pushToFavoritesViewController];
        }    break;
        case HomeMenuItemTypeSearchPosition: {
            [self handleSearchPositionEvent];
        }    break;
        case HomeMenuItemTypeAbout: {
            [self pushToSettingViewController];
        }    break;
        default:
            break;
    }
}

//  跳转到场景页面
- (void)pushToSceneViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SceneViewController *sceneViewController = (SceneViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SceneViewController"];
    sceneViewController.currentTitle = @"场景";
    [Bridge sharedInstance].pushToNewViewController(sceneViewController);
}

//  跳转到分析页面
- (void)showAnalyzeView {
    [Bridge sharedInstance].showAnalyzeView();
}

//  跳转到图层页面
- (void)pushToLayerViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LayerViewController *layerViewController = [storyboard instantiateViewControllerWithIdentifier:@"LayerViewController"];
    layerViewController.currentTitle = @"图层";
    SceneControl *sceneControl = (SceneControl *)self.superview;
    layerViewController.currentScene = sceneControl.scene;
    [Bridge sharedInstance].pushToNewViewController(layerViewController);
}

//  跳转到飞行页面
- (void)showFlyView {
    [Bridge sharedInstance].showFlyView();
}

//  路径搜索
- (void)handleSearchPositionEvent {
    BOOL hasSet = [Bridge sharedInstance].displaySearchAndRouteButton(visibleSearchAndRouteButton);
    if (hasSet) {
        visibleSearchAndRouteButton = !visibleSearchAndRouteButton;
    }
}

//  跳转到设置页面
- (void)pushToSettingViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SettingViewController *settingViewController = [storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    settingViewController.currentTitle = @"关于";
    [Bridge sharedInstance].pushToNewViewController(settingViewController);
}

//  跳转到兴趣点管理页面
- (void)pushToFavoritesViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    FavoritesViewController *favoritesViewController = [storyboard instantiateViewControllerWithIdentifier:@"FavoritesViewController"];
    favoritesViewController.currentTitle = @"兴趣点";
    [Bridge sharedInstance].pushToNewViewController(favoritesViewController);
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"HomeMenuTableViewCell";
    HomeMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeMenuTableViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //刷新cell
    NSString *title = _items[indexPath.row];
    NSString *imageName = _images[indexPath.row];
    [cell refreshCellWithTitle:title andImageName:imageName];
    
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HOMEMENU_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self pushWithIndexPath:indexPath];
}

- (void)adjustContentOffset {
    [self.homeMenu scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

@end
