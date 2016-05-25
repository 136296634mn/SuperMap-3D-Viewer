//
//  FavoritesSelectIconController.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/24.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "FavoritesSelectIconController.h"
#import "NavigationItem.h"
#import "Helper.h"
#import "FavoritesSelectIconCell.h"

static NSString * const kFavoritesSelectIconCell = @"kFavoritesSelectIconCell";

@interface FavoritesSelectIconController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FavoritesSelectIconController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = GetColor(241, 241, 241, 1.0);
    
    //  设置导航条属性
    [self.navigationItem setTitle:_currentTitle];
    [self.navigationItem setPopToPreviousViewController:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //  设置tableView数据源和代理
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self registerCell];
}

- (void)registerCell {
    [self.tableView registerClass:[FavoritesSelectIconCell class] forCellReuseIdentifier:kFavoritesSelectIconCell];
}

- (NSString *)iconNameWithIndexPath:(NSIndexPath *)indexPath {
    NSString *iconName = nil;
    switch (indexPath.row) {
        case 0:
            iconName = @"blupin.png";
            break;
        case 1:
            iconName = @"定位点－红.png";
            break;
        case 2:
            iconName = @"定位点－蓝.png";
            break;
    }
    return iconName;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoritesSelectIconCell *cell = [tableView dequeueReusableCellWithIdentifier:kFavoritesSelectIconCell];
    [cell refreshCellWithIconName:_iconName indexPath:indexPath];
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.resetIconName) {
        NSString *iconName = [self iconNameWithIndexPath:indexPath];
        self.resetIconName(iconName);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
