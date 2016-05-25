//
//  SettingAccessoryCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/12.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SettingAccessoryCell.h"
#import "UITableViewCell+RefreshData.h"

@implementation SettingAccessoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initialize];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    [self initialize];
    
    return self;
}

- (void)initialize {
    self.textLabel.font = [UIFont boldSystemFontOfSize:18];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)refreshCell:(id)data {
    if (![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *attributes = (NSDictionary *)data;
    self.textLabel.text = attributes[@"Title"];
}

@end
