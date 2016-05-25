//
//  TerrainCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/17.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "TerrainCell.h"

@interface TerrainCell ()

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@end

@implementation TerrainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshCell:(id)data {
    if (![data isKindOfClass:[NSString class]]) return;
    
    self.titleImageView.image = [UIImage imageNamed:(NSString *)data];
}

@end
