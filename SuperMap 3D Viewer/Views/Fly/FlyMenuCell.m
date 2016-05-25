//
//  FlyMenuCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/31.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "FlyMenuCell.h"

@implementation FlyMenuCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.textColor = [UIColor whiteColor];
}

- (void)refreshCell:(id)data {
    if ([data isKindOfClass:[NSString class]]) {
        self.textLabel.text = (NSString *)data;
    }
}

@end
