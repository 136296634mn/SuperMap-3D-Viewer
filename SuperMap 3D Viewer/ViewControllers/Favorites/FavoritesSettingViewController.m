//
//  FavoritesSettingViewController.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/20.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "FavoritesSettingViewController.h"
#import "NavigationItem.h"
#import "Helper.h"
#import "Bridge.h"
#import "FavoritesSettingCell.h"
#import "ZYDAttributeMenu.h"
#import "FavoritesSettingModel.h"
#import "FavoritesSettingCell.h"
#import "FavoritesSettingSwitchCell.h"
#import "FavoritesSettingIconCell.h"
#import "UITableViewCell+RefreshData.h"
#import "FavoritesSelectIconController.h"

static NSString * const kFavoritesSettingCell             = @"kFavoritesSettingCell";
static NSString * const kFavoritesSettingSwitchCell       = @"kFavoritesSettingSwitchCell";
static NSString * const kFavoritesSettingIconCell         = @"kFavoritesSettingIconCell";

@interface FavoritesSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FavoritesSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //  设置导航条属性
    [self.navigationItem setTitle:_currentTitle];
    [self.navigationItem setPopToPreviousViewController:^{
        if (self.deliverModel) self.deliverModel(self.model, self.indexPath);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self setupTableView];
}

//  设置表格视图
- (void)setupTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.scrollEnabled = NO;
    
    [self registerCell];
}

- (void)registerCell {
    [self.tableView registerClass:[FavoritesSettingCell class] forCellReuseIdentifier:kFavoritesSettingCell];
    [self.tableView registerClass:[FavoritesSettingSwitchCell class] forCellReuseIdentifier:kFavoritesSettingSwitchCell];
    [self.tableView registerClass:[FavoritesSettingIconCell class] forCellReuseIdentifier:kFavoritesSettingIconCell];
}

- (NSString *)identifierWithIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    switch (indexPath.row) {
        case 0:
            identifier = kFavoritesSettingCell;
            break;
        case 1:
            identifier = kFavoritesSettingSwitchCell;
            break;
        case 2:
            identifier = kFavoritesSettingIconCell;
            break;
        case 3:
            identifier = kFavoritesSettingCell;
            break;
        default:
            break;
    }
    return identifier;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self identifierWithIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ([cell isKindOfClass:[FavoritesSettingCell class]]) {
        FavoritesSettingCell *temp = (FavoritesSettingCell *)cell;
        [temp refreshCellWithModel:_model indexPath:indexPath];
    } else if ([cell isKindOfClass:[FavoritesSettingSwitchCell class]]) {
        FavoritesSettingSwitchCell *temp = (FavoritesSettingSwitchCell *)cell;
        [temp setShowFavorite:^(BOOL visible) {
            self.model.visible = visible;
        }];
        [temp refreshCell:_model];
    } else if ([cell isKindOfClass:[FavoritesSettingIconCell class]]) {
        [cell refreshCell:_model];
    }
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        [[ZYDAttributeMenu sharedInstance] showWithTitle:@"名称"];
        [[ZYDAttributeMenu sharedInstance] setText:cell.detailTextLabel.text];
        [[ZYDAttributeMenu sharedInstance] setCallBackBlock:^(NSString *text) {
            cell.detailTextLabel.text = text;
            self.model.name = text;
        }];
    } else if (indexPath.row == 2) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        FavoritesSelectIconController *selectIconController = [storyboard instantiateViewControllerWithIdentifier:@"FavoritesSelectIconController"];
        selectIconController.currentTitle = @"选择图标";
        selectIconController.iconName = _model.iconName;
        [selectIconController setResetIconName:^(NSString *iconName) {
            _model.iconName = iconName;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [Bridge sharedInstance].pushToNewViewController(selectIconController);
    } else if (indexPath.row == 3) {
        [[ZYDAttributeMenu sharedInstance] showWithTitle:@"描述信息"];
        [[ZYDAttributeMenu sharedInstance] setText:cell.detailTextLabel.text];
        [[ZYDAttributeMenu sharedInstance] setCallBackBlock:^(NSString *text) {
            cell.detailTextLabel.text = text;
            self.model.message = text;
        }];
    }
}

@end
