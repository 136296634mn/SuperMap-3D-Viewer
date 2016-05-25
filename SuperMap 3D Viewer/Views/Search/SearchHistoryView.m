//
//  SearchHistoryView.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/21.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SearchHistoryView.h"
#import "SearchCell.h"
#import "HttpDownload.h"
#import "SearchResultsModel.h"
#import "Helper.h"
#import "Animation.h"
#import "Bridge.h"
#import "SearchHistoryClearCell.h"
#import "UITableViewCell+RefreshData.h"

static NSString * const kSearchCell = @"kSearchCell";
static NSString * const kSearchHistoryClearCell = @"kSearchHistoryClearCell";

@interface SearchHistoryView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *items;

@end

@implementation SearchHistoryView

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
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.bounces = NO;
    tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self addSubview:tableView];
    self.tableView = tableView;
    
    [self registerCell];
}

- (void)registerCell {
    [self.tableView registerClass:[SearchCell class] forCellReuseIdentifier:kSearchCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchHistoryClearCell" bundle:nil] forCellReuseIdentifier:kSearchHistoryClearCell];
}

- (void)fetchHistoryDataSource {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *items = [userDefaults objectForKey:@"POIHistory"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        [temp addObject:model];
    }];
    self.items = temp;
}

- (void)refreshMenu {
    [self.tableView reloadData];
}

- (void)clearDataSource {
    if (self.items) self.items = nil;
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

- (void)clearPOIHistory {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"POIHistory"];
    [userDefaults synchronize];
    self.items = nil;
}

- (NSString *)identifierWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kSearchCell;
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
    if (!cell) {
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
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
        SearchResultsModel *model = (SearchResultsModel *)self.items[indexPath.row];
        [Bridge sharedInstance].addLandmark(model.loca.x, model.loca.y, model.name);
        [Bridge sharedInstance].flyToPoint(model.loca.x, model.loca.y);
        [Bridge sharedInstance].dismissSearchView();
        [Bridge sharedInstance].resetSearchView();
    } else if (indexPath.section == 1) {
        [self clearPOIHistory];
        [self.tableView reloadData];
    }
}

@end
