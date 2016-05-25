//
//  NavigationControl.m
//  Gesture
//
//  Created by zyd on 16/3/10.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "NavigationControl.h"

@implementation ZoomContrl {
    NSTimer *_timer;
}

// 当控件被点击是触发一个定时器
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
    _timer = nil;
}

// 处理定时器事件
- (void)handleTouchesEvent:(NSTimer *)timer {
    
}

@end

@interface NavigationControl ()

@property (strong, nonatomic) UIButton *northButton;
@property (strong, nonatomic) ZoomContrl *enlargeControl;
@property (strong, nonatomic) ZoomContrl *shrinkControl;

@end

@implementation NavigationControl

- (void)awakeFromNib {
    [self initialize];
    [self layout];
    self.backgroundColor = [UIColor redColor];
}

- (void)initialize {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    self.northButton = button;
    self.northButton.backgroundColor = [UIColor yellowColor];
    
    ZoomContrl *enlargeControl = [[ZoomContrl alloc] init];
    [self addSubview:enlargeControl];
    self.enlargeControl = enlargeControl;
    self.enlargeControl.backgroundColor = [UIColor blueColor];
    
    ZoomContrl *shrinkControl = [[ZoomContrl alloc] init];
    [self addSubview:shrinkControl];
    self.shrinkControl = shrinkControl;
    self.shrinkControl.backgroundColor = [UIColor purpleColor];
}

- (void)layout {
    
    // 指北按钮布局
    self.northButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_northButton
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_northButton
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_northButton
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_northButton
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
                                                           toItem:_northButton
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

@end
