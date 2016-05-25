//
//  SceneDataSource.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/15.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SceneDataSource.h"
#import "SceneCell.h"

@interface SceneDataSource ()

@property (strong, nonatomic) id items;
@property (copy, nonatomic) NSString *cellIdentifier;
@property (copy, nonatomic) TableViewCellRefreshBlock refreshBlock;

@end

@implementation SceneDataSource

- (instancetype)initWithItems:(id)items cellIdentifier:(NSString *)identifier refreshBlock:(TableViewCellRefreshBlock)block {
    self = [super init];
    if (!self) return nil;
    
    self.items = items;
    self.cellIdentifier = identifier;
    self.refreshBlock = block;
    
    return self;
}

+ (SceneDataSource *)dataSourceWithItems:(id)items cellIdentifier:(NSString *)identifier refreshBlock:(TableViewCellRefreshBlock)block {
    SceneDataSource *dataSource = [[SceneDataSource alloc] initWithItems:items
                                                          cellIdentifier:identifier
                                                            refreshBlock:block];
    return dataSource;
}

- (void)refreshData:(id)data {
    self.items = data;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)scetion {
    if ([self.items isKindOfClass:[NSArray class]]) {
        NSDictionary *dic = [(NSArray *)self.items objectAtIndex:scetion];
        NSArray *array = [dic allValues][0];
        return array.count;
    } else {
        NSArray *array = [(NSDictionary *)self.items allValues][0];
        return array.count;
    }
}

- (NSInteger)numberOfSections {
    if ([self.items isKindOfClass:[NSArray class]]) {
        return ((NSArray *)self.items).count;
    } else {
        return 1;
    }
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    id item = nil;
    if ([self.items isKindOfClass:[NSArray class]]) {
        NSDictionary *dic = [(NSArray *)self.items objectAtIndex:indexPath.section];
        NSArray *array = [dic allValues][0];
        if (array.count > 0) {
            item = [array objectAtIndex:indexPath.row];
        }
    } else {
        NSArray *array = [(NSDictionary *)self.items allValues][0];
        if (array.count > 0) {
            item = [array objectAtIndex:indexPath.row];
        }
    }
    return item;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SceneCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    id item = [self itemAtIndexPath:indexPath];
    self.refreshBlock(cell, item);
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self.items isKindOfClass:[NSArray class]]) {
        NSDictionary *dic = [(NSArray *)self.items objectAtIndex:section];
        NSString *str = [dic allKeys][0];
        return str;
    } else {
        NSString *str = [(NSDictionary *)self.items allKeys][0];
        return str;
    }
}

@end
