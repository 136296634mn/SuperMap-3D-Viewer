//
//  NoneCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/18.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "NoneCell.h"

@implementation NoneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
