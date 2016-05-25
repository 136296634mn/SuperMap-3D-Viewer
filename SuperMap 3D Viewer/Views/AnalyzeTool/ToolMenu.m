//
//  ToolMenu.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/18.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "ToolMenu.h"
#import "ToolDataSource.h"
#import "ToolDelegate.h"
#import "FavoritesCell.h"
#import "NoneCell.h"
#import "Helper.h"
#import "CancelButton.h"
#import "Animation.h"
#import "Supermap.h"
#import "SMFeature3D.h"
#import "Bridge.h"
#import <SuperMap/SuperMap.h>

static NSString * const kToolMenuTypeNone       = @"NoneCell";
static NSString * const kToolMenuTypeFavorites  = @"FavoritesCell";
static NSString * const kToolMenuTypeFly        = @"FlyCell";
static NSString * const kToolMenuTypeDistance   = @"DistanceCell";
static NSString * const kToolMenuTypeArea       = @"AreaCell";
static NSString * const kToolMenuTypeVisibility = @"VisibilityCell";

@interface ToolMenu ()

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *textView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) CancelButton *cancelButton;
@property (strong, nonatomic) UIView *separatorLine;
@property (strong, nonatomic) ToolDataSource *dataSource;
@property (strong, nonatomic) ToolDelegate *delegate;

@end

@implementation ToolMenu

- (void)awakeFromNib {
    [self initialize];
    [self layout];
}

- (void)initialize {
    UIView *contentView = [[UIView alloc] init];
    contentView.layer.cornerRadius = 10;
    contentView.layer.borderWidth = 2;
    contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    contentView.layer.masksToBounds = YES;
    contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UILabel *textView = [[UILabel alloc] init];
    textView.textColor = [UIColor whiteColor];
    textView.backgroundColor = GetColor(42.0, 42.0, 42.0, 0.8);
    textView.adjustsFontSizeToFitWidth = YES;
    textView.numberOfLines = 0;
    [self.contentView addSubview:textView];
    self.textView = textView;
    
    [self setupTableView];
    
    UIView *separatorLine = [[UIView alloc] init];
    separatorLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:separatorLine];
    self.separatorLine = separatorLine;
    
    CancelButton *button = [CancelButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 23;
    button.layer.borderWidth = 2;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.backgroundColor = [UIColor blackColor];
    [button setImage:[UIImage imageNamed:@"close@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleCancelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.cancelButton = button;
    
    self.layer.cornerRadius = 10;
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
}

- (void)layout {
    //  容器视图布局
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_contentView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_contentView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_contentView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_contentView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0]]];
    
    //  文本展示视图布局
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraints:@[[NSLayoutConstraint constraintWithItem:_textView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.contentView
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                                       [NSLayoutConstraint constraintWithItem:_textView
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f
                                                                     constant:0],
                                       [NSLayoutConstraint constraintWithItem:_textView
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f
                                                                     constant:0],
                                       [NSLayoutConstraint constraintWithItem:_textView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_separatorLine
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f
                                                                     constant:0]]];
    
    //  分割线布局
    self.separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraints:@[[NSLayoutConstraint constraintWithItem:_separatorLine
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.contentView
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                                       [NSLayoutConstraint constraintWithItem:_separatorLine
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f
                                                                     constant:0],
                                       [NSLayoutConstraint constraintWithItem:_separatorLine
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_tableView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f
                                                                     constant:0]]];
    [self.separatorLine addConstraint:[NSLayoutConstraint constraintWithItem:_separatorLine
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f
                                                                    constant:2]];
    
    //  表格视图布局
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraints:@[[NSLayoutConstraint constraintWithItem:_tableView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.contentView
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                                       [NSLayoutConstraint constraintWithItem:_tableView
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f
                                                                     constant:0],
                                       [NSLayoutConstraint constraintWithItem:_tableView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f
                                                                     constant:0]]];
    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0f
                                                                constant:60.0]];
    
    //  按钮布局
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_cancelButton
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:-23],
                           [NSLayoutConstraint constraintWithItem:_cancelButton
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:18]]];
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_cancelButton
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0f
                                                         constant:46],
                           [NSLayoutConstraint constraintWithItem:_cancelButton
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0f
                                                         constant:46]]];
}

//  创建表格视图
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.dataSource = [[ToolDataSource alloc] initWithCellIdentifier:kToolMenuTypeNone];
    tableView.dataSource = self.dataSource;
    self.delegate = [[ToolDelegate alloc] init];
    tableView.delegate = self.delegate;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = GetColor(25.0, 25.0, 25.0, 0.8);
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    
    [self registerCell];
}

- (void)registerCell {
    [self.tableView registerClass:[NoneCell class] forCellReuseIdentifier:kToolMenuTypeNone];
    [self.tableView registerNib:[UINib nibWithNibName:@"FavoritesCell" bundle:nil] forCellReuseIdentifier:kToolMenuTypeFavorites];
    [self.tableView registerNib:[UINib nibWithNibName:@"FlyCell" bundle:nil] forCellReuseIdentifier:kToolMenuTypeFly];
    [self.tableView registerNib:[UINib nibWithNibName:@"DistanceCell" bundle:nil] forCellReuseIdentifier:kToolMenuTypeDistance];
    [self.tableView registerNib:[UINib nibWithNibName:@"AreaCell" bundle:nil] forCellReuseIdentifier:kToolMenuTypeArea];
    [self.tableView registerNib:[UINib nibWithNibName:@"VisibilityCell" bundle:nil] forCellReuseIdentifier:kToolMenuTypeVisibility];
}

- (void)setType:(ToolMenuType)type {
    _type = type;
    self.dataSource.identifier = [self identifierWithType:type];
    [self.tableView reloadData];
}

//  根据TooMenu类型返回cell类型(关联ToolMenu和cell)
- (NSString *)identifierWithType:(ToolMenuType)type {
    NSString *identifier = nil;
    switch (type) {
        case ToolMenuTypeNone:
            identifier = kToolMenuTypeNone;
            break;
        case ToolMenuTypeFavorites:
            identifier = kToolMenuTypeFavorites;
            break;
        case ToolMenuTypeFly:
            identifier = kToolMenuTypeFly;
            break;
        case ToolMenuTypeDistance:
            identifier = kToolMenuTypeDistance;
            break;
        case ToolMenuTypeArea:
            identifier = kToolMenuTypeArea;
            break;
        case ToolMenuTypeVisibility:
            identifier = kToolMenuTypeVisibility;
            break;
    }
    return identifier;
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)refreshText:(NSString *)text {
    self.textView.text = text;
}

//  取消按钮点击事件
- (void)handleCancelButtonEvent:(id)sender {
    [self cancelToolMenuEvent];
    [Animation applyCancelAnimationToToolMenu:self];
    [Bridge sharedInstance].showHomeButton();
}

- (void)cancelToolMenuEvent {
    switch (self.type) {
        case ToolMenuTypeNone:
            break;
        case ToolMenuTypeFavorites:
            [self handleFavoritesEvent];
            break;
        case ToolMenuTypeFly:
            [self handleFlyEvent];
            break;
        case ToolMenuTypeDistance:
        case ToolMenuTypeArea:
        case ToolMenuTypeVisibility:
            [self handleAnalyzeEvent];
            break;
    }
    self.type = ToolMenuTypeNone;
}

//  处理兴趣点工具条事件
- (void)handleFavoritesEvent {
    if (_textView.text) {
        self.textView.text = @"";
    }
    if ([Supermap sharedInstance].smFeature3D.feature3D) {
        GeoPlacemark *placeMark = (GeoPlacemark *)[Supermap sharedInstance].smFeature3D.feature3D.geometry3D;
        GeoPoint3D *geoPoint3D = (GeoPoint3D *)placeMark.geometry;
        [Bridge sharedInstance].flyAroundPoint(geoPoint3D, 0);
    }
    if ([Supermap sharedInstance].smFeature3D.favorable) {
        [Bridge sharedInstance].saveFavorites();
    } else {
        [Bridge sharedInstance].removeFavorites();
    }
}

//  处理飞行工具条事件
- (void)handleFlyEvent {
    if (_textView.text) {
        self.textView.text = @"";
    }
    [Bridge sharedInstance].stopFlyRoute();
}

//  处理分析工具条事件
- (void)handleAnalyzeEvent {
    if (_textView.text) {
        self.textView.text = @"";
    }
    [Bridge sharedInstance].exitAnalyze();
}

//  取消按钮超出父视图事件处理
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    CGPoint buttonPoint = [self.cancelButton convertPoint:point fromView:self];
    if ([self.cancelButton pointInside:buttonPoint withEvent:event] && self.userInteractionEnabled == YES) {
        return self.cancelButton;
    }
    return result;
}

@end
