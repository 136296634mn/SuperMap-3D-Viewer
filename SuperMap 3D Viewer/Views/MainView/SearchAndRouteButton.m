//
//  SearchAndRouteButton.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/26.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SearchAndRouteButton.h"
#import "Helper.h"
#import "Bridge.h"

@implementation SearchAndRouteButton {
    UIButton *_routeButton;
    UIButton *_searchButton;
}

- (void)awakeFromNib {
    [self initialize];
    [self layout];
}

- (void)initialize {
    UIButton *routeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    routeButton.layer.borderWidth = 2.0;
    routeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    routeButton.layer.cornerRadius = 10;
    routeButton.layer.shadowOffset = CGSizeMake(0, 5);
    routeButton.layer.shadowOpacity = 1;
    routeButton.layer.shadowRadius = 10;
    routeButton.backgroundColor = GetColor(24.0, 24.0, 24.0, 0.8);
    [routeButton setImage:[UIImage imageNamed:@"icon_网络分析.png"] forState:UIControlStateNormal];
    [routeButton setImage:[UIImage imageNamed:@"icon_网络分析－按下.png"] forState:UIControlStateHighlighted];
    [routeButton addTarget:self action:@selector(handleRouteButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:routeButton];
    _routeButton = routeButton;
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.layer.borderWidth = 2.0;
    searchButton.layer.borderColor = [UIColor whiteColor].CGColor;
    searchButton.layer.cornerRadius = 10;
    searchButton.layer.shadowOffset = CGSizeMake(0, 5);
    searchButton.layer.shadowOpacity = 1;
    searchButton.layer.shadowRadius = 10;
    searchButton.backgroundColor = GetColor(24.0, 24.0, 24.0, 0.8);
    searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    UIImage *normalImage = [UIImage imageNamed:@"icon_搜索.png"];
    UIImage *highlightedImage = [UIImage imageNamed:@"icon_搜索－按下.png"];
    CGFloat distance;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        distance = 50;
    } else {
        distance = 40;
    }
    [searchButton setImage:[Helper originImage:normalImage scaleToSize:CGSizeMake(distance, distance)] forState:UIControlStateNormal];
    [searchButton setImage:[Helper originImage:highlightedImage scaleToSize:CGSizeMake(distance, distance)] forState:UIControlStateHighlighted];
    [searchButton setTitle:@"搜索地点" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor colorWithWhite:0.65 alpha:1.0] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(handleSearchButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:searchButton];
    _searchButton = searchButton;
    
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
}

- (void)handleRouteButtonEvent:(id)sender {
    [Bridge sharedInstance].showRouteMenu();
    [Bridge sharedInstance].routeViewFetchHistoryData();
    [Bridge sharedInstance].routeViewRefreshHistoryMenu();
    [Bridge sharedInstance].visibleRouteViewHistoryMenu(YES);
    [Bridge sharedInstance].visibleRouteViewResultsMenu(NO);
    self.hidden = YES;
    self.type = SearchTypeRoute;
}

- (void)handleSearchButtonEvent:(id)sender {
    [Bridge sharedInstance].showSearchMenu();
    self.hidden = YES;
    self.type = SearchTypeSearch;
}

- (void)layout {
    //  路径按钮布局
    _routeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_routeButton
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_routeButton
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_routeButton
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_routeButton
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_routeButton
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0f
                                                         constant:0]]];
    
    //  搜索按钮布局
    _searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_searchButton
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_searchButton
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_routeButton
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:8],
                           [NSLayoutConstraint constraintWithItem:_searchButton
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_searchButton
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0]]];
}

@end
