//
//  AttributeCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/20.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "AttributeCell.h"
#import "UITableViewCell+RefreshData.h"
#import "AttributeModel.h"

@interface AttributeCell ()

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation AttributeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
//    self.keyLabel.numberOfLines = 0;
//    self.valueLabel.numberOfLines = 0;
}

- (void)refreshCell:(id)data {
    if (![data isKindOfClass:[AttributeModel class]]) return;
    
    AttributeModel *model = (AttributeModel *)data;
    self.keyLabel.text = [NSString stringWithFormat:@"%@", model.key];
    self.valueLabel.text = [NSString stringWithFormat:@"%@", model.value];
}

@end
