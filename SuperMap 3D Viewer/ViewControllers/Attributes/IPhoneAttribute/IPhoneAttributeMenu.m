//
//  IPhoneAttributeMenu.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/26.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "IPhoneAttributeMenu.h"
#import "AttributeCell.h"
#import "UITableViewCell+RefreshData.h"
#import "Animation.h"
#import "AttributeModel.h"

@interface IPhoneAttributeMenu () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *items;

@end

@implementation IPhoneAttributeMenu

+ (IPhoneAttributeMenu *)sharedInstance {
    static IPhoneAttributeMenu *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[super allocWithZone:NULL] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return singleton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self initialize];
    [self layout];
    
    return self;
}

- (void)initialize {
    self.rootViewController = [[UIViewController alloc] init];
    self.rootViewController.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.rootViewController.view addSubview:tableView];
    self.tableView = tableView;
    
    [self registerCell];
}

- (void)registerCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"AttributeCell" bundle:nil] forCellReuseIdentifier:@"AttributeCell"];
}

- (void)layout {
    UIView *baseView = self.rootViewController.view;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [baseView addConstraints:@[[NSLayoutConstraint constraintWithItem:_tableView
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:baseView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0f
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:_tableView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:baseView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0f
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:_tableView
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:baseView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1.0f
                                                             constant:0]]];
    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0f
                                                                constant:0]];
}

- (void)showWithData:(id)data {
    self.items = data;
    [self makeKeyWindow];
    self.hidden = NO;
    [Animation applyExtendAnimationToAttributeMenu:self.tableView];
    [self.tableView reloadData];
}

- (CGFloat)cellHeightWithIndexPath:(NSIndexPath *)indexPath {
    AttributeModel *model = self.items[indexPath.row];
    if (model) {
        NSString *key = [NSString stringWithFormat:@"%@", model.key];
        NSString *value = [NSString stringWithFormat:@"%@", model.value];
        NSString *standardString = @"A";//  用于获取一行的高度
        CGSize keySize = [key boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width / 2, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]}
                                           context:nil].size;
        CGSize valueSize = [value boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width / 2, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]}
                                               context:nil].size;
        CGSize standardSize = [standardString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width / 2, MAXFLOAT)
                                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]}
                                                           context:nil].size;
        CGFloat blankHeight = 50 - standardSize.height;//   文字距顶部和底部的高度
        CGFloat maxHeight = keySize.height > valueSize.height ? keySize.height : valueSize.height;
        CGFloat totalHeight = maxHeight + blankHeight;
        if (totalHeight > 50) {
            return totalHeight;
        }
    }
    return 50;
}

#pragma mark -- Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [Animation applyShrinkAnimationToAttributeMenu:self.tableView
                                   expendAnimation:^{
                                       self.alpha = 0.0;
                                   }
                                        completion:^{
                                            [self resignKeyWindow];
                                            self.hidden = YES;
                                            self.alpha = 1.0;
                                        }];
    if (self.resignEvent) self.resignEvent();
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttributeCell"];
    id data = self.items[indexPath.row];
    if (data) [cell refreshCell:data];
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightWithIndexPath:indexPath];
}

@end
