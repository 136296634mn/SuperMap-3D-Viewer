//
//  AnalyzeMenu.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/15.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "AnalyzeMenu.h"
#import "AnalyzeHeader.h"
#import "Helper.h"
#import "HomeMenuTableViewCell.h"
#import "Bridge.h"

#define ANALYZEMENU_CELL_HEIGHT 60 //分析菜单cell高度

typedef NS_ENUM(NSUInteger, AnalyzeFunctionType) {
    AnalyzeFunctionTypeDistance = 0,
    AnalyzeFunctionTypeArea,
    AnalyzeFunctionTypeVisibility,
};

@interface AnalyzeMenu () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) AnalyzeHeader *headerView;
@property (strong, nonatomic) UITableView *homeMenu;
@property (strong, nonatomic) UIImageView *tailImageView;
@property (strong, nonatomic) UIView *leftLine;
@property (strong, nonatomic) UIView *rightLine;
@property (copy, nonatomic) NSArray *items;
@property (copy, nonatomic) NSArray *images;

@end

@implementation AnalyzeMenu

- (void)awakeFromNib {
    [self initialize];
    [self layout];
}

- (void)initialize {
    [self initializeDataSource];
    [self initializeUI];
}

//  初始化数据源
- (void)initializeDataSource {
    self.items = @[@"距离", @"面积", @"通视"];
    self.images = @[@"distance@2x.png", @"area@2x.png", @"viewshed@2x.png"];
}

//  初始化UI控件
- (void)initializeUI {
    AnalyzeHeader *headerView = [[AnalyzeHeader alloc] init];
    headerView.layer.contents = (__bridge id)[UIImage imageNamed:@"mm_top@2x.png"].CGImage;
    headerView.title = @"分析";
    [self addSubview:headerView];
    self.headerView = headerView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = GetColor(24.0, 24.0, 24.0, 0.85);
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:tableView];
    self.homeMenu = tableView;
    [self addSeparatorToTableView];
    
    UIImageView *tailImageView = [[UIImageView alloc] init];
    tailImageView.image = [UIImage imageNamed:@"mm_bottom@2x.png"];
    [self addSubview:tailImageView];
    self.tailImageView = tailImageView;
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:leftLine];
    self.leftLine = leftLine;
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:rightLine];
    self.rightLine = rightLine;
    
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
}

//  自定义UITableView分割线
- (void)addSeparatorToTableView {
    for (NSInteger i = 0; i < _items.count - 1; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (i + 1)*ANALYZEMENU_CELL_HEIGHT, 240, 1)];
        view.backgroundColor = [UIColor lightGrayColor];
        [self.homeMenu addSubview:view];
    }
}

//  布局控件
- (void)layout {
    //  顶部视图布局
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_headerView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_headerView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_headerView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0]]];
    [self.headerView addConstraints:@[[NSLayoutConstraint constraintWithItem:_headerView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:50]]];
    
    //  左侧白线布局
    self.leftLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_leftLine
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_homeMenu
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_leftLine
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_leftLine
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_homeMenu
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0]]];
    [self.leftLine addConstraint:[NSLayoutConstraint constraintWithItem:_leftLine
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0f
                                                               constant:2]];
    
    //  主UITableView布局
    self.homeMenu.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_homeMenu
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_headerView
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_homeMenu
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_leftLine
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_homeMenu
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_rightLine
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_homeMenu
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_tailImageView
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0]]];
    
    //  右侧白线布局
    self.rightLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_rightLine
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_homeMenu
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_rightLine
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_homeMenu
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_rightLine
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0]]];
    [self.rightLine addConstraint:[NSLayoutConstraint constraintWithItem:_rightLine
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0f
                                                                constant:2]];
    
    //  底部UIImageView布局
    self.tailImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_tailImageView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_tailImageView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_tailImageView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0]]];
    [self.tailImageView addConstraint:[NSLayoutConstraint constraintWithItem:_tailImageView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f
                                                                    constant:30]];
}

- (void)showToolMenuWithIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case AnalyzeFunctionTypeDistance:
            [Bridge sharedInstance].showDistanceToolMenu();
            break;
        case AnalyzeFunctionTypeArea:
            [Bridge sharedInstance].showAreaToolMenu();
            break;
        case AnalyzeFunctionTypeVisibility:
            [Bridge sharedInstance].showVisibilityToolMenu();
            break;
    }
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"HomeMenuTableViewCell";
    HomeMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeMenuTableViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //刷新cell
    NSString *title = _items[indexPath.row];
    NSString *imageName = _images[indexPath.row];
    [cell refreshCellWithTitle:title andImageName:imageName];
    
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ANALYZEMENU_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showToolMenuWithIndexPath:indexPath];
}

- (void)adjustContentOffset {
    [self.homeMenu scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

@end
