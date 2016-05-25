//
//  SceneOnlineDataSource.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/18.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SceneOnlineDataSource.h"
#import "SceneCell.h"

@interface SceneOnlineDataSource ()

@property (strong, nonatomic) id items;
@property (copy, nonatomic) NSString *cellIdentifier;
@property (copy, nonatomic) TableViewCellRefreshBlock refreshBlock;

@end

@implementation SceneOnlineDataSource

- (instancetype)initWithItems:(id)items cellIdentifier:(NSString *)identifier refreshBlock:(TableViewCellRefreshBlock)block {
    self = [super init];
    if (!self) return nil;
    
    self.items = items;
    self.cellIdentifier = identifier;
    self.refreshBlock = block;
    
    return self;
}

+ (SceneOnlineDataSource *)dataSourceWithItems:(id)items cellIdentifier:(NSString *)identifier refreshBlock:(TableViewCellRefreshBlock)block {
    SceneOnlineDataSource *dataSource = [[SceneOnlineDataSource alloc] initWithItems:items
                                                                      cellIdentifier:identifier
                                                                        refreshBlock:block];
    return dataSource;
}

- (void)refreshData:(id)data {
    self.items = data;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if ([self.items isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)self.items;
        if (section == 0) {
            NSArray *currentOnlines = [dic valueForKey:@"当前在线"];
            count = currentOnlines.count;
        } else if (section == 1) {
            NSArray *historyOnlines = [dic valueForKey:@"历史在线"];
            count = historyOnlines.count;
        }
    }
    return count;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    id item = nil;
    if (![self.items isKindOfClass:[NSDictionary class]]) return nil;
    
    NSDictionary *dic = (NSDictionary *)self.items;
    if (indexPath.section == 0) {
        NSArray *currentOnlines = [dic valueForKey:@"当前在线"];
        if (currentOnlines.count > 0) {
            item = currentOnlines[indexPath.row];
        }
    } else if (indexPath.section == 1) {
        NSArray *historyOnlines = [dic valueForKey:@"历史在线"];
        if (historyOnlines.count > 0) {
            item = historyOnlines[indexPath.row];
        }
    }
    return item;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SceneCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    id data = [self itemAtIndexPath:indexPath];
    if (data) self.refreshBlock(cell, data);
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    if (section == 0) {
        title = @"当前在线";
    } else if (section == 1) {
        title = @"历史在线";
    }
    return title;
}

@end
