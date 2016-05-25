//
//  ZYDAttributeMenu.m
//  ZYDAttributeView
//
//  Created by zyd on 16/3/23.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "ZYDAttributeMenu.h"
#import "ZYDAttributeView.h"

#define ATTRIBUTE_WIDTH 300
#define ATTRIBUTE_HEIGHT 200

@interface ZYDAttributeMenu ()

@property (strong, nonatomic) ZYDAttributeView *attributeView;

@end

@implementation ZYDAttributeMenu

+ (ZYDAttributeMenu *)sharedInstance {
    static ZYDAttributeMenu *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[super allocWithZone:NULL] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return singleton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self initialize];
    [self layout];
    
    return self;
}

- (void)initialize {
    self.rootViewController = [[UIViewController alloc] init];
    ZYDAttributeView *attributeView = [[ZYDAttributeView alloc] init];
    [attributeView setHide:^{
        [self resignKeyWindow];
        self.hidden = YES;
    }];
    [self.rootViewController.view addSubview:attributeView];
    self.attributeView = attributeView;
}

- (void)layout {
    UIView *baseView = self.rootViewController.view;
    self.attributeView.translatesAutoresizingMaskIntoConstraints = NO;
    [baseView addConstraints:@[[NSLayoutConstraint constraintWithItem:_attributeView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:baseView
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_attributeView
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:baseView
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0f
                                                         constant:-ATTRIBUTE_HEIGHT / 2]]];
    [self.attributeView addConstraints:@[[NSLayoutConstraint constraintWithItem:_attributeView
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f
                                                                       constant:ATTRIBUTE_WIDTH],
                                         [NSLayoutConstraint constraintWithItem:_attributeView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f
                                                                       constant:ATTRIBUTE_HEIGHT]]];
}

- (void)showWithTitle:(NSString *)title {
    [self.attributeView setTitle:title];
    [self makeKeyWindow];
    self.hidden = NO;
    [self applyScaleAnimationToMenu];
}

- (void)applyScaleAnimationToMenu {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @1.5;
    scaleAnimation.repeatCount = 1;
    scaleAnimation.autoreverses = YES;
    [self.attributeView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

@end
