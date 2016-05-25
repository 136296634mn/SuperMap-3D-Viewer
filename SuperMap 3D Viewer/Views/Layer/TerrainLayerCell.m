//
//  TerrainLayerCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/13.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "TerrainLayerCell.h"
#import "LayerModel.h"
#import "Helper.h"
#import "UITableViewCell+RefreshData.h"
#import "Bridge.h"

@interface TerrainLayerCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *visibleSwitch;
@property (strong, nonatomic) LayerModel *model;

@end

@implementation TerrainLayerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = GetColor(67.0, 67.0, 67.0, 1.0);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)refreshCell:(id)data {
    if (![data isKindOfClass:[LayerModel class]]) return;
    
    self.model = (LayerModel *)data;
    self.titleLabel.text = self.model.captionName;
    [self.visibleSwitch setOn:self.model.visible];
}

- (IBAction)visibleSwitchValueChanged:(UISwitch *)sender {
    [Bridge sharedInstance].layerVisible(self.model.layerName, sender.isOn);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
