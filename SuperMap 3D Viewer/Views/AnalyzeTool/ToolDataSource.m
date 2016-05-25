//
//  ToolDataSource.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/18.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "ToolDataSource.h"
#import "FavoritesCell.h"

@implementation ToolDataSource

- (instancetype)initWithCellIdentifier:(NSString *)identifier {
    self = [super init];
    if (!self) return nil;
    
    self.identifier = identifier;
    
    return self;
}

- (instancetype)dataSourceWithCellIdentifier:(NSString *)identifier {
    ToolDataSource *dataSource = [[ToolDataSource alloc] initWithCellIdentifier:identifier];
    return dataSource;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cell isKindOfClass:[FavoritesCell class]]) {
        [(FavoritesCell *)cell refreshCell];
    }
    return cell;
}

@end
