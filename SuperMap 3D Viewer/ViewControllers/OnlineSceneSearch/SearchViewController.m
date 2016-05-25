//
//  SearchViewController.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/18.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SearchViewController.h"
#import "Helper.h"
#import "LoaclDownloadQueue.h"
#import "Bridge.h"
#import "Reminder.h"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *items;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indictorView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = GetColor(241, 241, 241, 1.0);
    self.items = [[NSMutableArray alloc] init];
    
    [self initialize];
    
    //  获取搜索历史数据
    [self fetchData];
}

- (void)initialize {
    [self setupSearchBar];
    
    [self setupTableView];
    
    [self setupIndicatorView];
}

- (void)setupSearchBar {
    self.searchBar.delegate = self;
    self.searchBar.backgroundColor = GetColor(241, 241, 241, 1.0);
    self.searchBar.placeholder = @"输入iServer数据网址";
    self.searchBar.text = @"http://www.supermapol.com/realspace/services/3D-saercibao_dantihua_pvr/rest/realspace";
    self.searchBar.showsCancelButton = YES;
    [self resetCancelButtonWithName:@"取消"];
    [self removeCancelButtonBackground];
    [self performSelector:@selector(searchBarBecomeFirstResponder) withObject:nil afterDelay:0.3];
}

- (void)setupTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)setupIndicatorView {
    self.indictorView.backgroundColor = GetColor(24, 24, 24, 0.2);
    self.indictorView.layer.cornerRadius = 20;
    self.indictorView.hidden = YES;
}

- (void)searchBarBecomeFirstResponder {
    [self.searchBar becomeFirstResponder];
}

- (void)resetCancelButtonWithName:(NSString *)name {
    UIView *view = self.searchBar.subviews[0];
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)sub;
            [button setTitle:name forState:UIControlStateNormal];
        }
    }
}

- (void)removeCancelButtonBackground {
    UIView *view = self.searchBar.subviews[0];
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [sub removeFromSuperview];
        }
    }
}

- (void)fetchData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *items = [userDefaults objectForKey:@"OnlineSceneSearchHistory"];
    self.items = [items mutableCopy];
    if (self.items.count > 0) {
        [self.tableView reloadData];
    }
}

- (void)saveData:(id)data {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [userDefaults objectForKey:@"OnlineSceneSearchHistory"];
    NSMutableArray *items = nil;
    if (arr.count == 0) {
        items = [[NSMutableArray alloc] init];
    } else {
        if ([arr containsObject:data]) return;
        items = [arr mutableCopy];
    }
    [items insertObject:data atIndex:0];
    [userDefaults setObject:items forKey:@"OnlineSceneSearchHistory"];
    [userDefaults synchronize];
}

- (void)removeDataWithIndexPath:(NSIndexPath *)indexPath {
    [self.items removeObjectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:self.items forKey:@"OnlineSceneSearchHistory"];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)downloadDataWithURLString:(NSString *)URLString {
    [LoaclDownloadQueue downloadIServerData:^(NSArray *items) {
        self.indictorView.hidden = YES;
        [self.indictorView stopAnimating];
        if (items.count > 0) {
            [self saveData:URLString];
            [Bridge sharedInstance].deliverIServerSceneSearchResult(items);
            [self.navigationController popViewControllerAnimated:YES];
        }
    } URL:URLString];
}

#pragma mark -- UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [Reminder networkReachableWiFi];
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    BOOL reachable = [Reminder networkReachable];
    if (reachable) {
        self.indictorView.hidden = NO;
        [self.indictorView startAnimating];
        [self downloadDataWithURLString:searchBar.text];
    }
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *text = self.items[indexPath.row];
    cell.textLabel.text = text;
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"历史记录";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeDataWithIndexPath:indexPath];
    }
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor lightGrayColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.items[indexPath.row];
    self.searchBar.text = text;
    [self performSelector:@selector(searchBarSearchButtonClicked:) withObject:self.searchBar afterDelay:0];
}

#pragma mark -- Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}

@end
