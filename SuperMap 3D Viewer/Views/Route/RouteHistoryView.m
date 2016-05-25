//
//  RouteHistoryView.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/28.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "RouteHistoryView.h"
#import "Helper.h"
#import "Animation.h"
#import "UITableViewCell+RefreshData.h"
#import "RouteHistoryCell.h"
#import "HttpDownload.h"
#import "Bridge.h"

static NSString * const kRouteHistoryCell = @"kRouteHistoryCell";
static NSString * const kSearchHistoryClearCell = @"kSearchHistoryClearCell";

@interface RouteHistoryView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *items;

@end

@implementation RouteHistoryView

- (void)awakeFromNib {
    [self initialize];
    [self layout];
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    [self initialize];
    [self layout];
    
    return self;
}

- (void)initialize {
    [self setupTableView];
    
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.cornerRadius = 10;
    self.layer.shadowOffset = CGSizeMake(0, 5);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 10;
    self.backgroundColor = GetColor(24.0, 24.0, 24.0, 0.8);
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.bounces = NO;
    tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:tableView];
    if ([tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        [tableView setCellLayoutMarginsFollowReadableWidth:NO];
    }
    self.tableView = tableView;
    
    [self registerCell];
}

- (void)registerCell {
    [self.tableView registerClass:[RouteHistoryCell class] forCellReuseIdentifier:kRouteHistoryCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchHistoryClearCell" bundle:nil] forCellReuseIdentifier:kSearchHistoryClearCell];
}

- (void)fetchHistoryDataSource {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.items = [userDefaults objectForKey:@"RouteHistory"];
}

- (void)refreshMenu {
    [self.tableView reloadData];
}

- (void)clearRouteHistory {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"RouteHistory"];
    [userDefaults synchronize];
    self.items = nil;
}

- (void)layout {
    //  表格视图布局
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_tableView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_tableView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_tableView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_tableView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0]]];
}

- (NSString *)identifierWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kRouteHistoryCell;
    }
    return kSearchHistoryClearCell;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CGFloat height;
    if (self.items.count > 0) {
        height = self.items.count * 60 + 40;
    } else {
        height = 0;
    }
    [Animation applyDisplayAnimationToSearchHistoryMenu:self height:height];
    if (section == 0) {
        return self.items.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self identifierWithIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.layoutMargins = UIEdgeInsetsZero;
    if (!cell) {
        cell = [[RouteHistoryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    if (self.items.count > indexPath.row) {
        id item = self.items[indexPath.row];
        if (item) [cell refreshCell:item];
    }
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60.0;
    }
    if (self.items.count == 0) {
        return 0;
    }
    return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *route = self.items[indexPath.row];
        NSArray *arr = [route componentsSeparatedByString:@"——>"];
        NSString *origin = arr[0];
        NSString *destination = arr[1];
        [HttpDownload downloadRouteDataWithOrigin:origin
                                      destination:destination
                                          success:^(id items) {
                                              [Bridge sharedInstance].removeRoute();
                                              [Bridge sharedInstance].addRoute(items, origin, destination);
                                              [Bridge sharedInstance].setOriginAndDestination(origin, destination);
//                                              [Bridge sharedInstance].visibleRouteViewHistoryMenu(NO);
                                          }
                                          failure:^(HttpDownloadErrorType errorType) {
                                              
                                          }];
    } else if (indexPath.section == 1) {
        [self clearRouteHistory];
        [self.tableView reloadData];
    }
}

@end
