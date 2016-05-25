//
//  SettingViewController.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/16.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SettingViewController.h"
#import "NavigationItem.h"
#import "Helper.h"
#import "Bridge.h"
#import "SettingDetailCell.h"
#import "UITableViewCell+RefreshData.h"
#import "SettingAccessoryCell.h"
#import "SettingSwitchCell.h"
#import "IntroductionViewController.h"

static NSString * const kSettingCellTypeDetail = @"DetailCell";
static NSString * const kSettingCellTypeAccessory = @"AccessoryCell";
static NSString * const kSettingCellTypeSwitch = @"SwitchCell";

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingViewController

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
    [self.tableView registerClass:[SettingDetailCell class] forCellReuseIdentifier:kSettingCellTypeDetail];
    [self.tableView registerClass:[SettingAccessoryCell class] forCellReuseIdentifier:kSettingCellTypeAccessory];
    [self.tableView registerClass:[SettingSwitchCell class] forCellReuseIdentifier:kSettingCellTypeSwitch];
}

- (NSString *)identifierWithIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    switch (indexPath.row) {
        case 0:
            identifier = kSettingCellTypeDetail;
            break;
        case 1:
            identifier = kSettingCellTypeSwitch;
            break;
        case 2:
            identifier = kSettingCellTypeAccessory;
            break;
    }
    return identifier;
}

- (NSDictionary *)dataWithIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = nil;
    switch (indexPath.row) {
        case 0:
            data = @{@"Title" : @"版本",
                     @"DetailText" : [self version]};
            break;
        case 1:
            data = @{@"Title" : @"导航面板显示"};
            break;
        case 2:
            data = @{@"Title" : @"产品信息"};
            break;
    }
    return data;
}

- (NSString *)version {
    NSString *info = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *version = [NSString stringWithFormat:@"SuperMap 3D Viewer %@", info];
    return version;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [self identifierWithIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    id data = [self dataWithIndexPath:indexPath];
    if (data) [cell refreshCell:data];
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        IntroductionViewController *introductionViewController = (IntroductionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"IntroductionViewController"];
        introductionViewController.currentTitle = @"产品信息";
        [self.navigationController pushViewController:introductionViewController animated:YES];
    }
}

@end
