//
//  RouteView.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/28.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "RouteView.h"
#import "RouteBar.h"
#import "RouteHistoryView.h"
#import "RouteResultsView.h"
#import "Bridge.h"

@interface RouteView ()

@property (strong, nonatomic) RouteBar *routeBar;
@property (strong, nonatomic) RouteHistoryView *historyMenu;
@property (strong, nonatomic) RouteResultsView *resultsMenu;

@end

@implementation RouteView

- (void)awakeFromNib {
    [self initialize];
    [self layout];
}

- (void)initialize {
    RouteBar *routeBar = [[RouteBar alloc] init];
    [self addSubview:routeBar];
    self.routeBar = routeBar;
    
    RouteResultsView *resultsMenu = [[RouteResultsView alloc] init];
    resultsMenu.hidden = YES;
    [self addSubview:resultsMenu];
    self.resultsMenu = resultsMenu;
    
    RouteHistoryView *historyMenu = [[RouteHistoryView alloc] init];
    [self addSubview:historyMenu];
    self.historyMenu = historyMenu;
    
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    
    [self bridgeEvent];//   block事件
}

- (void)bridgeEvent {
    [[Bridge sharedInstance] setRouteViewFetchSearchData:^(NSString *text) {
        [self.resultsMenu fetchDataSourceWithKeywords:text];
    }];//   <--获取搜索数据
    [[Bridge sharedInstance] setRouteViewRefreshResultsMenu:^{
        [self.resultsMenu refreshMenu];
    }];//   <--刷新搜索结果列表
    [[Bridge sharedInstance] setSelectRouteResultsCellEvent:^(NSString *text) {
        [self.routeBar setActiveTextFieldText:text];
        [self.routeBar nextTextField];
        self.resultsMenu.hidden = YES;
    }];//   <--选择cell
    [[Bridge sharedInstance] setVisibleRouteViewResultsMenu:^(BOOL visible) {
        self.resultsMenu.hidden = !visible;
    }];//   <--设置搜索结果列表是否可见
    [[Bridge sharedInstance] setVisibleRouteViewHistoryMenu:^(BOOL visible) {
        self.historyMenu.hidden = !visible;
    }];//   <--设置历史列表是否可见
    [[Bridge sharedInstance] setRouteViewFetchHistoryData:^{
        [self.historyMenu fetchHistoryDataSource];
    }];//   <--获取历史数据
    [[Bridge sharedInstance] setRouteViewRefreshHistoryMenu:^{
        [self.historyMenu refreshMenu];
    }];//   <--刷新历史列表
    [[Bridge sharedInstance] setSetOriginAndDestination:^(NSString *origin, NSString *destination) {
        [self.routeBar setOrigin:origin destination:destination];
    }];//   <--设置起始点终止点
}

- (void)layout {
    //  路线搜索条布局
    self.routeBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_routeBar
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_routeBar
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_routeBar
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0]]];
    [self.routeBar addConstraint:[NSLayoutConstraint constraintWithItem:_routeBar
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0f
                                                                constant:100]];
    
    //  搜索结果菜单布局
    self.resultsMenu.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_resultsMenu
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_routeBar
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:10],
                           [NSLayoutConstraint constraintWithItem:_resultsMenu
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_resultsMenu
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_resultsMenu
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0]]];
    
    //  路线搜索历史菜单布局
    self.historyMenu.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_historyMenu
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_routeBar
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:10],
                           [NSLayoutConstraint constraintWithItem:_historyMenu
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_historyMenu
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0]]];
    [self.historyMenu addConstraint:[NSLayoutConstraint constraintWithItem:_historyMenu
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f
                                                                  constant:0]];
}

- (BOOL)isEditing {
    return self.routeBar.isEditing;
}
    
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint routeBarPoint = [self.routeBar convertPoint:point fromView:self];
    CGPoint historyMenuPoint = [self.historyMenu convertPoint:point fromView:self];
    CGPoint resultsMenuPoint = [self.resultsMenu convertPoint:point fromView:self];
    if ([self.routeBar pointInside:routeBarPoint withEvent:event]) {
        return YES;
    }
    if ([self.historyMenu pointInside:historyMenuPoint withEvent:event]) {
        if (self.historyMenu.isHidden && self.resultsMenu.isHidden) {
            return NO;
        }
        return YES;
    }
    if ([self.resultsMenu pointInside:resultsMenuPoint withEvent:event]) {
        if (self.resultsMenu.isHidden) {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (void)clearData {
    [self.routeBar clearContent];
}

@end
