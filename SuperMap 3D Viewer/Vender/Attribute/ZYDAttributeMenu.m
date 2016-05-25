//
//  ZYDAttributeMenu.m
//  ZYDAttributeView
//
//  Created by zyd on 16/3/23.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "ZYDAttributeMenu.h"

#define ATTRIBUTE_WIDTH 300
#define ATTRIBUTE_HEIGHT 200

@implementation ZYDAttributeMenu {
    UIView *_attributeView;
    UILabel *_titleLabel;
    UITextField *_textField;
    UIButton *_confirmButton;
    UIButton *_cancelButton;
}

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
    self.rootViewController.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
    UIView *attributeView = [[UIView alloc] init];
    attributeView.layer.cornerRadius = 10;
    attributeView.layer.borderWidth = 2;
    attributeView.layer.borderColor = [UIColor whiteColor].CGColor;
    attributeView.layer.masksToBounds = YES;
    attributeView.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:0.8];
    [self.rootViewController.view addSubview:attributeView];
    _attributeView = attributeView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    [_attributeView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.layer.cornerRadius = 10;
    textField.layer.borderWidth =1;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.textColor = [UIColor whiteColor];
    [_attributeView addSubview:textField];
    _textField = textField;
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.layer.cornerRadius = 5;
    confirmButton.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(handleConfirmButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_attributeView addSubview:confirmButton];
    _confirmButton = confirmButton;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.layer.cornerRadius = 5;
    cancelButton.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(handleCancelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_attributeView addSubview:cancelButton];
    _cancelButton = cancelButton;
}

- (void)layout {
    
#pragma mark --
    UIView *baseView = self.rootViewController.view;
    _attributeView.translatesAutoresizingMaskIntoConstraints = NO;
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
    [_attributeView addConstraints:@[[NSLayoutConstraint constraintWithItem:_attributeView
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
    
#pragma mark -- 
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_attributeView addConstraints:@[[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_attributeView
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0f
                                                                   constant:0],
                                     [NSLayoutConstraint constraintWithItem:_titleLabel
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_attributeView
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0f
                                                                   constant:10],
                                     [NSLayoutConstraint constraintWithItem:_titleLabel
                                                                  attribute:NSLayoutAttributeRight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_attributeView
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0f
                                                                   constant:0]]];
    [_titleLabel addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0f
                                                             constant:50]];
    
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    [_attributeView addConstraints:@[[NSLayoutConstraint constraintWithItem:_textField
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_titleLabel
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:10],
                                     [NSLayoutConstraint constraintWithItem:_textField
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_attributeView
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0f
                                                                   constant:10],
                                     [NSLayoutConstraint constraintWithItem:_textField
                                                                  attribute:NSLayoutAttributeRight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_attributeView
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0f
                                                                   constant:-10],
                                     [NSLayoutConstraint constraintWithItem:_textField
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_confirmButton
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0f
                                                                   constant:-30]]];
    
    _confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_attributeView addConstraints:@[[NSLayoutConstraint constraintWithItem:_confirmButton
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_attributeView
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0f
                                                                   constant:10],
                                     [NSLayoutConstraint constraintWithItem:_confirmButton
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_attributeView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:-10]]];
    [_confirmButton addConstraints:@[[NSLayoutConstraint constraintWithItem:_confirmButton
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:100],
                                     [NSLayoutConstraint constraintWithItem:_confirmButton
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:40]]];
    
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_attributeView addConstraints:@[[NSLayoutConstraint constraintWithItem:_cancelButton
                                                                  attribute:NSLayoutAttributeRight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_attributeView
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0f
                                                                   constant:-10],
                                     [NSLayoutConstraint constraintWithItem:_cancelButton
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_attributeView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:-10]]];
    [_cancelButton addConstraints:@[[NSLayoutConstraint constraintWithItem:_cancelButton
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f
                                                                  constant:100],
                                    [NSLayoutConstraint constraintWithItem:_cancelButton
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f
                                                                  constant:40]]];

}

- (void)showWithTitle:(NSString *)title {
    _titleLabel.text = title;
    [self makeKeyWindow];
    self.hidden = NO;
    [_textField becomeFirstResponder];
    [self applyExtendAnimationToMenu];
}

- (void)applyExtendAnimationToMenu {
    CGFloat scale = 1.2;
    _attributeView.transform = CGAffineTransformScale(_attributeView.transform, scale, scale);
    [UIView animateWithDuration:0.3 animations:^{
        _attributeView.transform = CGAffineTransformScale(_attributeView.transform, 1 / scale, 1 / scale);
    }];
}

- (void)applyShrinkAnimationToMenu {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _attributeView.transform = CGAffineTransformScale(_attributeView.transform, 0.5, 0.5);
                         _attributeView.alpha = 0.1;
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self resignKeyWindow];
                         self.hidden = YES;
                         self.alpha = 1.0;
                         _attributeView.alpha = 1.0;
                         _attributeView.transform = CGAffineTransformScale(_attributeView.transform, 2, 2);
                     }];
}

- (void)setText:(NSString *)text {
    _text = text;
    _textField.text = _text;
}

- (void)handleConfirmButtonEvent:(id)sender {
    if (self.callBackBlock) self.callBackBlock(_textField.text);
    [self resign];
}

- (void)handleCancelButtonEvent:(id)sender {
    [self resign];
}

- (void)resign {
    if (_textField.isEditing) [_textField resignFirstResponder];
    [self applyShrinkAnimationToMenu];
}

@end
