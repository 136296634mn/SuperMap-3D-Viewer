//
//  SearchView.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/25.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SearchView.h"
#import "SearchBar.h"
#import "SearchResultsMenu.h"
#import "Bridge.h"
#import "SearchHistoryView.h"
#import "Reminder.h"

@interface SearchView () <UITextFieldDelegate>

@property (strong, nonatomic) SearchBar *searchBar;
@property (strong, nonatomic) SearchResultsMenu *resultsMenu;
@property (strong, nonatomic) SearchHistoryView *historyMenu;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation SearchView

- (void)awakeFromNib {
    [self initialize];
    [self layout];
}

- (void)initialize {
    SearchBar *searchBar = [[SearchBar alloc] init];
    searchBar.delegate = self;
    [searchBar addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:searchBar];
    self.searchBar = searchBar;
    
    SearchResultsMenu *resultsMenu = [[SearchResultsMenu alloc] init];
    resultsMenu.hidden = YES;
    [self addSubview:resultsMenu];
    self.resultsMenu = resultsMenu;
    
    SearchHistoryView *historyMenu = [[SearchHistoryView alloc] init];
    [self addSubview:historyMenu];
    self.historyMenu = historyMenu;
    
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    
    [self bridgeEvent];//   block传递事件
}

- (void)bridgeEvent {
    [[Bridge sharedInstance] setResetSearchView:^{
        if (!self.resultsMenu.hidden) self.resultsMenu.hidden = YES;
        if (self.historyMenu.hidden) self.historyMenu.hidden = NO;
    }];
}

- (void)clearData {
    if (self.searchBar.text) self.searchBar.text = nil;
    [self.resultsMenu clearDataSource];
    [self.resultsMenu refreshMenu];
}

- (BOOL)resignFirstResponder {
    BOOL isSearchBarResign = [self.searchBar resignFirstResponder];
    BOOL isSuperResign = [super resignFirstResponder];
    if (isSearchBarResign && isSuperResign) {
        return YES;
    }
    return NO;
}

- (BOOL)isEditing {
    return self.searchBar.isEditing;
}

- (void)setShouldBeginEditing:(BOOL)shouldBeginEditing {
    _shouldBeginEditing = shouldBeginEditing;
    if (shouldBeginEditing) [self.searchBar becomeFirstResponder];
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
                                                                constant:50]];
    
    //  搜索结果菜单布局
    self.resultsMenu.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_resultsMenu
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_searchBar
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
    
    //  搜索历史菜单布局
    self.historyMenu.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_historyMenu
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_searchBar
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

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint searchBarPoint = [self.searchBar convertPoint:point fromView:self];
    CGPoint historyMenuPoint = [self.historyMenu convertPoint:point fromView:self];
    CGPoint resultsMenuPoint = [self.resultsMenu convertPoint:point fromView:self];
    if ([self.searchBar pointInside:searchBarPoint withEvent:event]) {
        return YES;
    }
    if ([self.historyMenu pointInside:historyMenuPoint withEvent:event]) {
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

#pragma mark -- Timer

- (void)refreshTableView:(NSTimer *)timer {
    [self.resultsMenu refreshMenu];
}

- (void)invalidateTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [Reminder networkReachable];

    [self.historyMenu fetchHistoryDataSource];
    [self.historyMenu refreshMenu];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                              target:self
                                            selector:@selector(refreshTableView:)
                                            userInfo:nil
                                             repeats:YES];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    self.historyMenu.hidden = YES;
    self.resultsMenu.hidden = NO;
    [self.resultsMenu fetchDataSourceWithKeywords:textField.text];
    if ([textField.text isEqualToString:@""]) {
        self.historyMenu.hidden = NO;
        self.resultsMenu.hidden = YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self invalidateTimer];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self invalidateTimer];
    [textField resignFirstResponder];
    return YES;
}

@end
