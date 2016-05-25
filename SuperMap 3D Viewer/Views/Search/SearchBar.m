//
//  SearchBar.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/21.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SearchBar.h"
#import "Helper.h"
#import "Bridge.h"
#import "SearchView.h"
#import "Animation.h"
#import "SearchClearButton.h"

@implementation SearchBar {
    SearchClearButton *_clearButton;
    UIButton *_backButton;
}

- (void)awakeFromNib {
    [self initialize];
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    [self initialize];
    
    return self;
}

- (void)initialize {
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.cornerRadius = 10;
    self.layer.shadowOffset = CGSizeMake(0, 5);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 10;
    self.backgroundColor = GetColor(24.0, 24.0, 24.0, 0.8);
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont systemFontOfSize:20];
    self.returnKeyType = UIReturnKeySearch;
    self.keyboardAppearance = UIKeyboardAppearanceDark;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入地名"
                                                                 attributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.65 alpha:1.0]}];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [_backButton setImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(handleBackButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.leftView = _backButton;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    _clearButton = [[SearchClearButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [_clearButton addTarget:self action:@selector(handleClearButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.rightView = _clearButton;
    self.rightViewMode = UITextFieldViewModeWhileEditing;
}

- (void)handleBackButtonEvent:(id)sender {
    [self resignFirstResponder];
    [Bridge sharedInstance].dismissSearchView();
    [Bridge sharedInstance].resetSearchView();
}

- (void)handleClearButtonEvent:(id)sender {
    self.text = @"";
}

@end
