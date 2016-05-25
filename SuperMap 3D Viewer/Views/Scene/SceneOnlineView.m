//
//  SceneOnlineView.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/19.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SceneOnlineView.h"
#import "SceneOnlineDataSource.h"
#import "SceneOnlineDelegate.h"
#import "SceneModel.h"
#import "SceneCell.h"
#import "Helper.h"
#import "SearchViewController.h"
#import "Bridge.h"

@interface SceneOnlineView () <UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *onlineTableView;
@property (strong, nonatomic) SceneOnlineDataSource *onlineDataSource;
@property (strong, nonatomic) SceneOnlineDelegate *onlineDelegate;
@property (strong, nonatomic) id items;

@end

@implementation SceneOnlineView

- (void)awakeFromNib {
    [self initialize];
    [self layout];
}

- (void)initialize {
    self.backgroundColor = GetColor(241, 241, 241, 1.0);
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.backgroundColor = GetColor(241, 241, 241, 1.0);
    searchBar.placeholder = @"输入iServer数据网址";
    searchBar.delegate = self;
    [self addSubview:searchBar];
    self.searchBar = searchBar;
    [self removeCancelButtonBackground];
    
    [self setupTableView];
}

- (void)setupTableView {
    self.onlineTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    if ([self.onlineTableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        [self.onlineTableView setCellLayoutMarginsFollowReadableWidth:NO];
    }
    [self addSubview:self.onlineTableView];
    [self registerCell];
    TableViewCellRefreshBlock onlineBlock = ^(SceneCell *cell, SceneModel *model) {
        [cell refreshData:model];
    };
    self.onlineDataSource = [SceneOnlineDataSource dataSourceWithItems:_items
                                                        cellIdentifier:@"SceneCell"
                                                          refreshBlock:onlineBlock];
    self.onlineTableView.dataSource = self.onlineDataSource;
    self.onlineDelegate = [SceneOnlineDelegate delegateWithItems:_items];
    self.onlineTableView.delegate = self.onlineDelegate;
    self.onlineTableView.tableFooterView = [[UIView alloc] init];
}

- (void)registerCell {
    [self.onlineTableView registerClass:[SceneCell class] forCellReuseIdentifier:@"SceneCell"];
}

- (void)removeCancelButtonBackground {
    UIView *view = self.searchBar.subviews[0];
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [sub removeFromSuperview];
        }
    }
}

- (void)refreshData:(id)data {
    self.items = data;
    [self.onlineDataSource refreshData:data];
    [self.onlineDelegate refreshData:data];
    [self.onlineTableView reloadData];
}

- (void)layout {
    //  搜索条布局
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_searchBar
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_searchBar
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_searchBar
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0]]];
    [self.searchBar addConstraint:[NSLayoutConstraint constraintWithItem:_searchBar
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0f
                                                                constant:40]];
    
    //  列表布局
    self.onlineTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_onlineTableView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_searchBar
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:5],
                           [NSLayoutConstraint constraintWithItem:_onlineTableView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_onlineTableView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_onlineTableView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0]]];
}

#pragma mark -- UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SearchViewController *searchViewController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [Bridge sharedInstance].nextVC(searchViewController);
    return NO;
}

@end
