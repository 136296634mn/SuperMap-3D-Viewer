//
//  Layer3DCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/12.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "Layer3DCell.h"
#import "UITableViewCell+RefreshData.h"
#import "LayerModel.h"
#import "Bridge.h"
#import "Helper.h"

@interface Layer3DCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectionButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *visibleSwitch;
@property (strong, nonatomic) UIImage *imageOn;
@property (strong, nonatomic) UIImage *imageOff;
@property (strong, nonatomic) LayerModel *model;

@end

@implementation Layer3DCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageOn = [UIImage imageNamed:@"checkbox_on@2x.png"];
    self.imageOff = [UIImage imageNamed:@"checkbox_off@2x.png"];
    self.titleLabel.textColor = GetColor(67.0, 67.0, 67.0, 1.0);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.selectionButton setImage:_imageOff forState:UIControlStateNormal];
}

- (void)refreshCell:(id)data {
    if (![data isKindOfClass:[LayerModel class]]) return;
    
    self.model = (LayerModel *)data;
    self.titleLabel.text = self.model.layerName;
    [self.visibleSwitch setOn:self.model.visible];
    if (self.model.selectable) {
        [self.selectionButton setImage:_imageOn forState:UIControlStateNormal];
    } else {
        [self.selectionButton setImage:_imageOff forState:UIControlStateNormal];
    }
}

- (IBAction)selectionButtonEvent:(UIButton *)sender {
    UIImage *image = [sender imageForState:UIControlStateNormal];
    if ([image isEqual:_imageOn]) {
        [self.selectionButton setImage:_imageOff forState:UIControlStateNormal];
        [Bridge sharedInstance].layerSelectable(self.model.layerName, NO);
    } else if ([image isEqual:_imageOff]) {
        [self.selectionButton setImage:_imageOn forState:UIControlStateNormal];
        [Bridge sharedInstance].layerSelectable(self.model.layerName, YES);
    }
}

- (IBAction)visibleSwitchValueChanged:(UISwitch *)sender {
    [Bridge sharedInstance].layerVisible(self.model.layerName, sender.isOn);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
