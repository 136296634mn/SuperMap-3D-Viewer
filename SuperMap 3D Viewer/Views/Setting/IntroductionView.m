//
//  IntroductionView.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/27.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "IntroductionView.h"
#import "Helper.h"

@interface IntroductionView ()

@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UITextView *textView;

@end

@implementation IntroductionView

- (void)awakeFromNib {
    [self initialize];
    [self layout];
}

- (void)initialize {
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"supermap-logo-GRB.png"];
    [self addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    UITextView *textView = [[UITextView alloc] init];
    textView.editable = NO;
    textView.selectable = NO;
    textView.textColor = [UIColor darkTextColor];
    textView.font = [UIFont italicSystemFontOfSize:14];
    textView.text = [self text];
    [self addSubview:textView];
    self.textView = textView;
}

- (NSString *)text {
    return @"新增支持倾斜摄影建模数据浏览与单体化功能；\n\n新增兴趣点标注功能，支持添加、编辑（兴趣点的图标、文字信息和描述信息）、保存与删除兴趣点；\n\n新增位置搜索功能，根据在输入框中输入位置，然后单击搜索按钮，即可通过SuperMap Online服务进行搜索；\n\n新增路径分析功能，输入起始点和终止点信息，通过SuperMap Online服务进行路径分析，并将结果展示在三维场景中。\n\n\n\n配套产品与版本：SuperMap iDesktop 8C sp1 或以上，SuperMap iServer 8C sp1 或以上。";
}

- (void)layout {
    //  logo图标控件布局
    self.logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_logoImageView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:50],
                           [NSLayoutConstraint constraintWithItem:_logoImageView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0f
                                                         constant:0]]];
    [self.logoImageView addConstraints:@[[NSLayoutConstraint constraintWithItem:_logoImageView
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f
                                                                       constant:240],
                                         [NSLayoutConstraint constraintWithItem:_logoImageView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f
                                                                       constant:60]]];
    
    //  文本控件布局
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_textView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_logoImageView
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:50],
                           [NSLayoutConstraint constraintWithItem:_textView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:10],
                           [NSLayoutConstraint constraintWithItem:_textView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:-10],
                           [NSLayoutConstraint constraintWithItem:_textView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:-10]]];
}

@end
