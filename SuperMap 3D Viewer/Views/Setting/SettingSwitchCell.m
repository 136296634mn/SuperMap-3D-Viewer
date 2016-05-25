//
//  SettingSwitchCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/12.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SettingSwitchCell.h"
#import "UITableViewCell+RefreshData.h"
#import "Bridge.h"

@interface SettingSwitchCell ()

@property (strong, nonatomic) UISwitch *displaySwitch;

@end

@implementation SettingSwitchCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UISwitch *displaySwitch = [[UISwitch alloc] init];
    [displaySwitch addTarget:self
                      action:@selector(displaySwitchEventHandle:)
            forControlEvents:UIControlEventValueChanged];
    displaySwitch.on = [self isOn];
    self.displaySwitch = displaySwitch;
    self.accessoryView = self.displaySwitch;
}

- (void)refreshCell:(id)data {
    if (![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *attributes = (NSDictionary *)data;
    self.textLabel.text = attributes[@"Title"];
}

- (BOOL)isOn {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [userDefaults objectForKey:@"NavigationDisplay"];
    BOOL isOn = YES;
    if (number) {
        isOn = [number boolValue];
    }
    return isOn;
}

- (void)setIsOn:(BOOL)isOn {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isOn forKey:@"NavigationDisplay"];
    [userDefaults synchronize];
}

- (void)displaySwitchEventHandle:(UISwitch *)displaySwitch {
    [Bridge sharedInstance].displayNavigationControl(displaySwitch.isOn);//  设置Navigation可见性
    [self setIsOn:displaySwitch.isOn];
}

@end
