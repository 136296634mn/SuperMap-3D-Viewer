//
//  SceneOnlineDelegate.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/18.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SceneOnlineDelegate.h"
#import "SceneModel.h"
#import "Bridge.h"
#import "Helper.h"

@interface SceneOnlineDelegate ()

@property (strong, nonatomic) id items;

@end

@implementation SceneOnlineDelegate

- (instancetype)initWithItems:(id)items {
    self = [super init];
    if (!self) return nil;
    
    self.items = items;
    
    return self;
}

+ (SceneOnlineDelegate *)delegateWithItems:(id)items {
    SceneOnlineDelegate *delegate = [[SceneOnlineDelegate alloc] initWithItems:items];
    return delegate;
}

- (void)refreshData:(id)data {
    self.items = data;
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
