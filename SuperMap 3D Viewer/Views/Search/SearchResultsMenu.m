//
//  SearchResultsMenu.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/22.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SearchResultsMenu.h"
#import "SearchCell.h"
#import "HttpDownload.h"
#import "SearchResultsModel.h"
#import "Helper.h"
#import "Animation.h"
#import "UITableViewCell+RefreshData.h"
#import "Bridge.h"

static NSString * const kSearchCell = @"kSearchCell";

@interface SearchResultsMenu () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *button;
@property (copy, nonatomic) NSArray *items;
@property (strong, nonatomic) UIImage *extendImage;
@property (strong, nonatomic) UIImage *shrinkImage;

@end

@implementation SearchResultsMenu

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
    
    self.extendImage = [Helper originImage:[UIImage imageNamed:@"icon_展开.png"] scaleToSize:CGSizeMake(30, 30)];
    self.shrinkImage = [Helper originImage:[UIImage imageNamed:@"icon_收起.png"] scaleToSize:CGSizeMake(30, 30)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:self.shrinkImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleSearchMenuButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.button = button;
    
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
}

- (void)fetchDataSourceWithKeywords:(NSString *)keywords {
    [HttpDownload downloadSearchDataWithKeywords:keywords
                                         success:^(id items) {
                                             if (self.items.count > 0) {
                                                 self.items = nil;
                                             }
                                             self.items = items;
                                         }
                                         failure:^(HttpDownloadErrorType errorType) {
                                         }];
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
                                                           toItem:_button
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0]]];
    
    //  按钮视图布局
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_button
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_button
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_button
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0]]];
    [self.button addConstraint:[NSLayoutConstraint constraintWithItem:_button
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0f
                                                             constant:40]];
}

- (void)handleSearchMenuButtonEvent:(UIButton *)sender {
    UIImage *currentImage = [sender imageForState:UIControlStateNormal];
    if ([currentImage isEqual:self.shrinkImage]) {
        [sender setImage:self.extendImage forState:UIControlStateNormal];
        [Animation applyShrinkAnimationToSearchMenu:self.superview];
        [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:NO];
    } else if ([currentImage isEqual:self.extendImage]) {
        [sender setImage:self.shrinkImage forState:UIControlStateNormal];
        [Animation applyExtendAnimationToSearchMenu:self.superview];
    }
}

- (void)savePOIHistory:(id)model {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [userDefaults objectForKey:@"POIHistory"];
    NSMutableArray *items = nil;
    if (arr.count == 0) {
        items = [[NSMutableArray alloc] init];
    } else {
        if ([arr containsObject:data]) return;
        items = [arr mutableCopy];
    }
    [items insertObject:data atIndex:0];
    if (items.count > 10) {
        [items removeLastObject];
    }
    [userDefaults setObject:items forKey:@"POIHistory"];
    [userDefaults synchronize];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchCell];
    if (!cell) {
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kSearchCell];
    }
    if (self.items.count > indexPath.row) {
        id item = self.items[indexPath.row];
        if (item) [cell refreshCell:item];
    }
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultsModel *model = (SearchResultsModel *)self.items[indexPath.row];
    [Bridge sharedInstance].addLandmark(model.loca.x, model.loca.y, model.name);
    [Bridge sharedInstance].flyToPoint(model.loca.x, model.loca.y);
    [Bridge sharedInstance].dismissSearchView();
    [Bridge sharedInstance].resetSearchView();
    [self savePOIHistory:model];
}

@end
