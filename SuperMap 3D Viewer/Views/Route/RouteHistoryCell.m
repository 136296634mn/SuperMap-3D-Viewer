//
//  RouteHistoryCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/22.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "RouteHistoryCell.h"
#import "UITableViewCell+RefreshData.h"

@implementation RouteHistoryCell

- (void)awakeFromNib {
    // Initialization code
    [self initialize];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    [self initialize];
    
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor whiteColor];
    self.detailTextLabel.textColor = [UIColor whiteColor];
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor darkGrayColor];
    self.selectedBackgroundView = backgroundView;
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 20);
}

- (void)refreshCell:(id)data {
    if ([data isKindOfClass:[NSString class]]) {
        self.textLabel.text = (NSString *)data;
    }
}

@end
