//
//  SceneDelegate.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/15.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SceneDelegate.h"
#import "SceneModel.h"
#import "Bridge.h"

@interface SceneDelegate () 

@property (strong, nonatomic) id items;

@end

@implementation SceneDelegate

- (instancetype)initWithItems:(id)items {
    self = [super init];
    if (!self) return nil;
    
    self.items = items;
    
    return self;
}

+ (SceneDelegate *)delegateWithItems:(id)items {
    SceneDelegate *delegate = [[SceneDelegate alloc] initWithItems:items];
    return delegate;
}

- (void)refreshData:(id)data {
    self.items = data;
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

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SceneModel *model = [self itemAtIndexPath:indexPath];
    [Bridge sharedInstance].openScene(model);
    [Bridge sharedInstance].popToRootViewController();
}

@end
