//
//  FavoritesViewController.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/20.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "FavoritesViewController.h"
#import "NavigationItem.h"
#import "Helper.h"
#import "Bridge.h"
#import "FavoritesManageCell.h"
#import "LoaclDownloadQueue.h"
#import "ViewController.h"
#import "FavoritesSettingViewController.h"
#import "FavoritesSettingModel.h"

@interface FavoritesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = GetColor(241, 241, 241, 1.0);
    self.items = [[NSMutableArray alloc] init];
    
    //  设置导航条属性
    [self.navigationItem setTitle:_currentTitle];
    [self.navigationItem setPopToPreviousViewController:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //  设置表格视图
    [self setupTableView];
    
    //  获取本地兴趣点数据
    [self fetchData];
}

- (void)setupTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)fetchData {
    UIViewController *rootViewController = self.navigationController.viewControllers[0];
    [LoaclDownloadQueue downloadFavoritesData:^(id items) {
        self.items = [items mutableCopy];
        [self.tableView reloadData];
    } sceneControl:(SceneControl *)rootViewController.view];
}

//  跳转到收藏设置页面
- (void)pushToFavoritesSettingViewControllerWithIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    FavoritesSettingViewController *favoritesSettingVC = (FavoritesSettingViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FavoritesSettingViewController"];
    favoritesSettingVC.currentTitle = @"属性设置";
    favoritesSettingVC.model = _items[indexPath.row];
    favoritesSettingVC.indexPath = indexPath;
    favoritesSettingVC.deliverModel = ^(FavoritesSettingModel *model, NSIndexPath *indexPath){
        [self resetFeature3DWithModel:model indexPath:indexPath];
    };
    [Bridge sharedInstance].pushToNewViewController(favoritesSettingVC);
}

//  更新数据源(兴趣点管理页面)
- (void)updateItemsWithModel:(FavoritesSettingModel *)model indexPath:(NSIndexPath *)indexPath {
    [self.items replaceObjectAtIndex:indexPath.row withObject:model];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

//  根据返回的模型数据重置Feature3D属性
- (void)resetFeature3DWithModel:(FavoritesSettingModel *)model indexPath:(NSIndexPath *)indexPath {
    [self updateItemsWithModel:model indexPath:indexPath];
    [Bridge sharedInstance].updateFavorite(model, indexPath);
}

- (NSArray *)createRightButtons {
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    MGSwipeButton * deleteButton = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:GetColor(65, 65, 65, 1.0) callback:^BOOL(MGSwipeTableCell * sender){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        // 首先删除数据源
        [self.items removeObjectAtIndex:indexPath.row];
        // 接着刷新view
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //  同步删除本地数据源
        [Bridge sharedInstance].removeFeature3D(indexPath);
        return YES;
    }];
    deleteButton.buttonWidth = 60.0 * 1.1;
    [result addObject:deleteButton];
    
    MGSwipeButton * editButton = [MGSwipeButton buttonWithTitle:@"编辑" backgroundColor:[UIColor lightGrayColor] callback:^BOOL(MGSwipeTableCell * sender){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        // 实现相关的逻辑代码
        [self pushToFavoritesSettingViewControllerWithIndexPath:indexPath];
        return YES;
    }];
    editButton.buttonWidth = 60.0 * 1.1;
    [result addObject:editButton];
    
    return result;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"FavoritesManageCell";
    FavoritesManageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[FavoritesManageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
    cell.rightButtons = [self createRightButtons];
    FavoritesSettingModel *model = self.items[indexPath.row];
    if (model) [cell refreshCell:model];
    return cell;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

//- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        // 实现相关的逻辑代码
//        [self pushToFavoritesSettingViewControllerWithIndexPath:indexPath];
//        // 在最后希望cell可以自动回到默认状态，所以需要退出编辑模式
//        tableView.editing = NO;
//    }];
//    editAction.backgroundColor = [UIColor lightGrayColor];
//    
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        // 首先删除数据源
//        [self.items removeObjectAtIndex:indexPath.row];
//        // 接着刷新view
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        //  同步删除本地数据源
//        [Bridge sharedInstance].removeFeature3D(indexPath);
//        // 不需要主动退出编辑模式，上面更新view的操作完成后就会自动退出编辑模式
//    }];
//    deleteAction.backgroundColor = GetColor(65, 65, 65, 1.0);
//    
//    return @[deleteAction, editAction];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [Bridge sharedInstance].flyToFeature3D(indexPath);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
