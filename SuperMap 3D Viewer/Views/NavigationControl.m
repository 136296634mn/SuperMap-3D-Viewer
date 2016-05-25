//
//  NavigationControl.m
//  Gesture
//
//  Created by zyd on 16/3/10.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "NavigationControl.h"
#import "Helper.h"
#import "Bridge.h"

@implementation CompassButton

@end

@implementation ZoomContrl {
    NSTimer *_timer;
}

// 当控件被点击时触发一个定时器
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                              target:self
                                            selector:@selector(handleTouchesEvent:)
                                            userInfo:nil
                                             repeats:YES];
    return YES;
}

// 控件恢复时移除定时器
- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    [_timer invalidate];
    if (_timer) _timer = nil;
}

// 处理定时器事件
- (void)handleTouchesEvent:(NSTimer *)timer {
    switch (_type) {
        case ZoomControlTypeMinus:
            [Bridge sharedInstance].zoom(-0.03);
            break;
        case ZoomControlTypePlus:
            [Bridge sharedInstance].zoom(0.03);
            break;
        default:
            break;
    }
}

@end

@interface NavigationControl ()

@property (strong, nonatomic) CompassButton *compassButton;
@property (strong, nonatomic) ZoomContrl *enlargeControl;
@property (strong, nonatomic) ZoomContrl *shrinkControl;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation NavigationControl

- (void)awakeFromNib {
    [self initialize];
    [self layout];
}

- (void)initialize {
    CompassButton *button = [CompassButton buttonWithType:UIButtonTypeCustom];
    CGFloat distance;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        distance = 8;
    } else {
        distance = 10;
    }
    [button setImageEdgeInsets:UIEdgeInsetsMake(distance, 0, distance, 0)];
    [button setImage:[UIImage imageNamed:@"icon_定位.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_定位－按下.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(north:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.compassButton = button;
    
    ZoomContrl *enlargeControl = [[ZoomContrl alloc] init];
    enlargeControl.layer.contents = (__bridge id)[UIImage imageNamed:@"icon_放大.png"].CGImage;
    enlargeControl.layer.contentsScale = [UIScreen mainScreen].scale;
    enlargeControl.layer.contentsGravity = kCAGravityResizeAspect;
    enlargeControl.type = ZoomControlTypePlus;
    [self addSubview:enlargeControl];
    self.enlargeControl = enlargeControl;
    
    ZoomContrl *shrinkControl = [[ZoomContrl alloc] init];
    shrinkControl.layer.contents = (__bridge id)[UIImage imageNamed:@"icon_缩小.png"].CGImage;
    shrinkControl.layer.contentsScale = [UIScreen mainScreen].scale;
    shrinkControl.layer.contentsGravity = kCAGravityResizeAspect;
    shrinkControl.type = ZoomControlTypeMinus;
    [self addSubview:shrinkControl];
    self.shrinkControl = shrinkControl;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                  target:self
                                                selector:@selector(compassStatusTracking:)
                                                userInfo:nil
                                                 repeats:YES];
    
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.masksToBounds = YES;
    self.backgroundColor = GetColor(24.0, 24.0, 24.0, 0.9);
}

- (void)layout {
    
    // 指北按钮布局
    self.compassButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_compassButton
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_compassButton
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_compassButton
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_compassButton
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_enlargeControl
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:-2]]];
    
    // 放大控件布局
    self.enlargeControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_enlargeControl
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_enlargeControl
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_enlargeControl
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_shrinkControl
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:-2],
                           [NSLayoutConstraint constraintWithItem:_enlargeControl
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_compassButton
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0f
                                                         constant:0]]];
    
    // 缩小控件布局
    self.shrinkControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_shrinkControl
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_shrinkControl
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_shrinkControl
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_shrinkControl
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_enlargeControl
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0f
                                                         constant:0]]];
}

- (void)compassStatusTracking:(NSTimer *)timer {
    double heading = [Bridge sharedInstance].compass();
    CGFloat angle = (360 - heading) * 2 * M_PI / 360;
//    _compassButton.layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1);
    _compassButton.transform = CGAffineTransformMakeRotation(angle);
}

- (void)north:(UIButton *)sender {
    if (self.north) self.north();
    [UIView animateWithDuration:0.35 animations:^{
//        _compassButton.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
        _compassButton.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
    }];
}

- (void)dealloc {
    [self.timer invalidate];
}

@end
