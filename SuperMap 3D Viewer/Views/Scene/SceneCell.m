//
//  SceneCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/15.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SceneCell.h"
#import "SceneModel.h"
#import "Helper.h"

@implementation SceneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.textLabel.textColor = GetColor(67.0, 67.0, 67.0, 1.0);
    
    return self;
}

- (void)refreshData:(SceneModel *)model {
    self.textLabel.text = model.senceName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
