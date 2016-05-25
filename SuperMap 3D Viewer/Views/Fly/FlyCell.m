//
//  FlyCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/31.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "FlyCell.h"
#import "Bridge.h"
#import "Helper.h"

NSString *const FlyCellChangeImageNotification = @"FlyCellChangeImageNotification";

@interface FlyCell ()

@property (weak, nonatomic) IBOutlet UIButton *home;
@property (weak, nonatomic) IBOutlet UIButton *playAndPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) UIImage *playImage;
@property (strong, nonatomic) UIImage *pauseImage;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenButton;

@end

@implementation FlyCell

- (void)awakeFromNib {
    // Initialization code
    [self.home setImage:[UIImage imageNamed:@"icon_主菜单.png"] forState:UIControlStateNormal];
    [self.home setImage:[UIImage imageNamed:@"icon_主菜单－按下.png"] forState:UIControlStateHighlighted];
    self.playImage = [UIImage imageNamed:@"iPad_play@2x.png"];
    self.pauseImage = [UIImage imageNamed:@"iPad_pause@2x.png"];
    self.backgroundColor = [UIColor clearColor];
    [self.playAndPauseButton setImage:_playImage forState:UIControlStateNormal];
    [self.stopButton setImage:[UIImage imageNamed:@"iPad_stop.png"] forState:UIControlStateNormal];
    UIImage *fullscreenImage = [UIImage imageNamed:@"fullscreen@2x.png"];
    [self.fullScreenButton setImage:[Helper originImage:fullscreenImage scaleToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(flyCellChangeImage:)
                                                 name:FlyCellChangeImageNotification
                                               object:nil];
}

- (IBAction)handleHomeButtonEvent:(id)sender {
    [Bridge sharedInstance].handleHomeButtonEvent();
}

- (IBAction)handlePlayAndPauseButtonEvent:(id)sender {
    UIImage *image = [self.playAndPauseButton imageForState:UIControlStateNormal];
    if ([image isEqual:_playImage]) {
        [self.playAndPauseButton setImage:_pauseImage forState:UIControlStateNormal];
        [Bridge sharedInstance].startFlyRoute();
    } else {
        [self.playAndPauseButton setImage:_playImage forState:UIControlStateNormal];
        [Bridge sharedInstance].pauseFlyRoute();
    }
}

- (IBAction)handleStopButtonEvent:(id)sender {
    UIImage *image = [self.playAndPauseButton imageForState:UIControlStateNormal];
    [Bridge sharedInstance].stopFlyRoute();
    if ([image isEqual:_pauseImage]) {
        [self.playAndPauseButton setImage:_playImage forState:UIControlStateNormal];
    }
}

- (IBAction)handleFullScreenButtonEvent:(id)sender {
    [Bridge sharedInstance].fullScreen();
}

- (void)flyCellChangeImage:(NSNotification *)noti {
    [self.playAndPauseButton setImage:_playImage forState:UIControlStateNormal];
}

@end
