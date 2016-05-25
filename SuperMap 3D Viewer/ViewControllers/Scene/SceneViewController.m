//
//  SceneViewController.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/14.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SceneViewController.h"
#import "Helper.h"
#import "Bridge.h"
#import "NavigationItem.h"
#import "SceneDataSource.h"
#import "SceneDelegate.h"
#import "SceneCell.h"
#import "LoaclDownloadQueue.h"
#import "SceneModel.h"
#import "SceneOnlineView.h"

@interface SceneViewController ()

@property (weak, nonatomic) IBOutlet NavigationItem *navigationItem;
@property (strong, nonatomic) id items;
@property (strong, nonatomic) SceneDataSource *dataSource;
@property (strong, nonatomic) SceneDelegate *delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SceneOnlineView *onlineView;
@property (strong, nonatomic) NSMutableDictionary *onlines;

@end

@implementation SceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = GetColor(241, 241, 241, 1.0);
    self.onlines = [[NSMutableDictionary alloc] init];
    
    [self bridgeEvent];
    
    //  设置导航条属性
    [self.navigationItem setTitle:_currentTitle];
    [self.navigationItem setPopToPreviousViewController:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //  设置tableView数据源和代理
    [self setupTableView];
    //  获取本地或网络数据
    [self fetchData];
}

- (void)bridgeEvent {
    [[Bridge sharedInstance] setPopToRootViewController:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [[Bridge sharedInstance] setDeliverIServerSceneSearchResult:^(NSArray *items) {
        [self.onlines setObject:items forKey:@"当前在线"];
        [self.onlineView refreshData:_onlines];
    }];//   <--传递iServer在线场景搜索结果
}

- (void)setupTableView {
    [self registerCell];
    TableViewCellRefreshBlock block = ^(SceneCell *cell, SceneModel *model) {
        [cell refreshData:model];
    };
    self.dataSource = [SceneDataSource dataSourceWithItems:_items
                                            cellIdentifier:@"SceneCell"
                                              refreshBlock:block];
    self.tableView.dataSource = self.dataSource;
    self.delegate = [SceneDelegate delegateWithItems:_items];
    self.tableView.delegate = self.delegate;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)registerCell {
    [self.tableView registerClass:[SceneCell class] forCellReuseIdentifier:@"SceneCell"];
}

- (void)fetchData {
    [LoaclDownloadQueue downloadSceneData:^(id items) {
        self.items = items;
        [self reloadTableViewWithItems:self.items];
        NSDictionary *dic = self.items[2];
        NSArray *arr = dic[@"在线"];
        [self.onlines setObject:arr forKey:@"历史在线"];
        [self.onlineView refreshData:_onlines];
    }];
}

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        id items = self.items;
        [self reloadTableViewWithItems:items];
    } else if (sender.selectedSegmentIndex < 3) {
        id items = self.items[sender.selectedSegmentIndex - 1];
        [self reloadTableViewWithItems:items];
    } else {
        [self reloadOnlineViewWithItems:self.onlines];
    }
}

- (void)reloadTableViewWithItems:(id)items {
    [self.dataSource refreshData:items];
    [self.delegate refreshData:items];
    [self.tableView reloadData];
    self.tableView.hidden = NO;
    self.onlineView.hidden = YES;
}

- (void)reloadOnlineViewWithItems:(id)items {
    [self.onlineView refreshData:items];
    self.onlineView.hidden = NO;
    self.tableView.hidden = YES;
}

@end
