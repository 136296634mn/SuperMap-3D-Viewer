//
//  RouteBar.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/28.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "RouteBar.h"
#import "Helper.h"
#import "Animation.h"
#import "Bridge.h"
#import "HttpDownload.h"
#import "Reminder.h"

@interface RouteBar () <UITextFieldDelegate>

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UITextField *originTextField;
@property (strong, nonatomic) UITextField *destinationTextField;
@property (strong, nonatomic) UIButton *exchangeButton;
@property (strong, nonatomic) UIView *separatorline1;
@property (strong, nonatomic) UIView *separatorline2;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation RouteBar

- (void)awakeFromNib {
    [self initialize];
    [self layout];
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    [self initialize];
    [self layout];
    
    return self;
}

- (void)initialize {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(handleBackButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    self.backButton = backButton;
    
    UITextField *originTextField = [[UITextField alloc] init];
    originTextField.textColor = [UIColor whiteColor];
    originTextField.font = [UIFont systemFontOfSize:18];
    originTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    originTextField.returnKeyType = UIReturnKeySearch;
    originTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    originTextField.enablesReturnKeyAutomatically = YES;
    originTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入起点"
                                                                            attributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.65 alpha:1.0]}];
    [originTextField addTarget:self action:@selector(originTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [originTextField addTarget:self action:@selector(originTextFieldDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    UIImageView *originLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    originLeftView.image = [UIImage imageNamed:@"icon_起点.png"];
    originTextField.leftView = originLeftView;
    originTextField.leftViewMode = UITextFieldViewModeAlways;
    originTextField.delegate = self;
    [self addSubview:originTextField];
    self.originTextField = originTextField;
    
    UITextField *destinationTextField = [[UITextField alloc] init];
    destinationTextField.textColor = [UIColor whiteColor];
    destinationTextField.font = [UIFont systemFontOfSize:18];
    destinationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    destinationTextField.returnKeyType = UIReturnKeySearch;
    destinationTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    destinationTextField.enablesReturnKeyAutomatically = YES;
    destinationTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入终点"
                                                                                 attributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.65 alpha:1.0]}];
    [destinationTextField addTarget:self action:@selector(destinationTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [destinationTextField addTarget:self action:@selector(destinationTextFieldDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    UIImageView *destinationLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    destinationLeftView.image = [UIImage imageNamed:@"icon_终点.png"];
    destinationTextField.leftView = destinationLeftView;
    destinationTextField.leftViewMode = UITextFieldViewModeAlways;
    destinationTextField.delegate = self;
    [self addSubview:destinationTextField];
    self.destinationTextField = destinationTextField;
    
    UIButton *exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeButton.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 30, 0);
    [exchangeButton setImage:[UIImage imageNamed:@"icon_路径切换.png"] forState:UIControlStateNormal];
    [exchangeButton setImage:[UIImage imageNamed:@"icon_路径切换－按下.png"] forState:UIControlStateHighlighted];
    [exchangeButton addTarget:self action:@selector(handleExchangeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:exchangeButton];
    self.exchangeButton = exchangeButton;
    
    UIView *separatorline1 = [[UIView alloc] init];
    separatorline1.backgroundColor = [UIColor clearColor];
    [self addSubview:separatorline1];
    self.separatorline1 = separatorline1;
    
    UIView *separatorline2 = [[UIView alloc] init];
    separatorline2.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:separatorline2];
    self.separatorline2 = separatorline2;
    
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.cornerRadius = 10;
    self.layer.shadowOffset = CGSizeMake(0, 5);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 10;
    self.backgroundColor = GetColor(24.0, 24.0, 24.0, 0.8);
}

- (void)handleBackButtonEvent:(id)sender {
    [self resign];
    [Bridge sharedInstance].removeRoute();
    [Bridge sharedInstance].dismissRouteView();
    [Bridge sharedInstance].visibleRouteViewResultsMenu(NO);
    [Bridge sharedInstance].visibleRouteViewHistoryMenu(NO);
}

- (void)handleExchangeButtonEvent:(id)sender {
    NSString *temp = self.originTextField.text;
    self.originTextField.text = self.destinationTextField.text;
    self.destinationTextField.text = temp;
    if (self.originTextField.editing) {
        [self.originTextField resignFirstResponder];
    } else if (self.destinationTextField.editing) {
        [self.destinationTextField resignFirstResponder];
    }
}

- (void)resign {
    if (self.originTextField.isEditing) {
        [self.originTextField resignFirstResponder];
    } else if (self.destinationTextField.isEditing) {
        [self.destinationTextField resignFirstResponder];
    }
}

- (void)clearContent {
    if (self.originTextField.text) {
        self.originTextField.text = nil;
    }
    if (self.destinationTextField.text) {
        self.destinationTextField.text = nil;
    }
}

//  保存搜索历史记录
- (void)saveRouteHistoryWithOrigin:(NSString *)origin destination:(NSString *)destination {
    if ([origin isEqualToString:@""] || [destination isEqualToString:@""]) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [userDefaults objectForKey:@"RouteHistory"];
    NSMutableArray *routes = nil;
    NSString *route = [NSString stringWithFormat:@"%@——>%@", origin, destination];
    if (arr.count == 0) {
        routes = [[NSMutableArray alloc] init];
    } else {
        if ([arr containsObject:route]) return;
        routes = [arr mutableCopy];
    }
    [routes insertObject:route atIndex:0];
    if (routes.count > 10) {
        [routes removeLastObject];
    }
    [userDefaults setObject:routes forKey:@"RouteHistory"];
    [userDefaults synchronize];
}

- (void)setActiveTextFieldText:(NSString *)text {
    if (self.originTextField.isEditing) {
        self.originTextField.text = text;
    } else if (self.destinationTextField.isEditing) {
        self.destinationTextField.text = text;
    }
}

- (void)nextTextField {
    if (self.originTextField.isEditing) {
        if ([self.destinationTextField.text isEqualToString:@""]) {
            [self.destinationTextField becomeFirstResponder];
        } else {
            [self.originTextField resignFirstResponder];
            [Bridge sharedInstance].removeTrackingLayerGeometry(@"Route");
            [Bridge sharedInstance].removeTrackingLayerGeometry(@"Landmark");
            [self downloadRouteDataWithOrigin:self.originTextField.text destination:self.destinationTextField.text];
        }
    } else if (self.destinationTextField.isEditing) {
        if ([self.originTextField.text isEqualToString:@""]) {
            [self.originTextField becomeFirstResponder];
        } else {
            [self.destinationTextField resignFirstResponder];
            [Bridge sharedInstance].removeTrackingLayerGeometry(@"Route");
            [Bridge sharedInstance].removeTrackingLayerGeometry(@"Landmark");
            [self downloadRouteDataWithOrigin:self.originTextField.text destination:self.destinationTextField.text];
        }
    }
}

- (void)downloadRouteDataWithOrigin:(NSString *)origin destination:(NSString *)destination {
    [HttpDownload downloadRouteDataWithOrigin:origin
                                  destination:destination
                                      success:^(id items) {
                                          [Bridge sharedInstance].addRoute(items, origin, destination);
                                          [self saveRouteHistoryWithOrigin:origin destination:destination];
                                      }
                                      failure:^(HttpDownloadErrorType errorType) {
                                          
                                      }];
}

- (void)visibleMenuWithText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        [Bridge sharedInstance].visibleRouteViewResultsMenu(NO);
        [Bridge sharedInstance].visibleRouteViewHistoryMenu(YES);
    } else {
        [Bridge sharedInstance].visibleRouteViewResultsMenu(YES);
        [Bridge sharedInstance].visibleRouteViewHistoryMenu(NO);
    }
}

- (void)setOrigin:(NSString *)origin destination:(NSString *)destination {
    self.originTextField.text = origin;
    self.destinationTextField.text = destination;
    if (self.originTextField.isEditing) [self.originTextField resignFirstResponder];
    if (self.destinationTextField.isEditing) [self.destinationTextField resignFirstResponder];
}

- (BOOL)isEditing {
    return (self.originTextField.isEditing || self.destinationTextField.isEditing) ? YES : NO;
}

- (void)layout {
    //  返回按钮布局
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_backButton
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_backButton
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_backButton
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_backButton
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_backButton
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:0.5f
                                                         constant:0]]];
    
    //  分割线1布局
    self.separatorline1.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_separatorline1
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_separatorline1
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_backButton
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_separatorline1
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0]]];
    [self.separatorline1 addConstraint:[NSLayoutConstraint constraintWithItem:_separatorline1
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f
                                                                     constant:1]];
    
    //  起始地点输入框布局
    self.originTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_originTextField
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_originTextField
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_separatorline1
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_originTextField
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_separatorline2
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_originTextField
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_exchangeButton
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0]]];
    
    //  分割线2布局
    self.separatorline2.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_separatorline2
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_separatorline1
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_separatorline2
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_destinationTextField
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_separatorline2
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_exchangeButton
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0]]];
    [self.separatorline2 addConstraint:[NSLayoutConstraint constraintWithItem:_separatorline2
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f
                                                                     constant:1]];
    
    //  终止地点输入框布局
    self.destinationTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_destinationTextField
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_separatorline1
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_destinationTextField
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_destinationTextField
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_exchangeButton
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_destinationTextField
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_originTextField
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0f
                                                         constant:0]]];
    
    //  交换起始位置和终点位置按钮布局
    self.exchangeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_exchangeButton
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_exchangeButton
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_exchangeButton
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_exchangeButton
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_exchangeButton
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:0.5f
                                                         constant:0]]];
}

#pragma mark -- Timer

- (void)refreshTableView:(NSTimer *)timer {
    [Bridge sharedInstance].routeViewRefreshResultsMenu();
}

- (void)invalidateTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [Reminder networkReachable];
    [Bridge sharedInstance].visibleRouteViewHistoryMenu(YES);
    [Bridge sharedInstance].visibleRouteViewResultsMenu(NO);
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                              target:self
                                            selector:@selector(refreshTableView:)
                                            userInfo:nil
                                             repeats:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.originTextField]) {
        if ([self.destinationTextField.text isEqualToString:@""]) {
            textField.returnKeyType = UIReturnKeyNext;
        } else {
            textField.returnKeyType = UIReturnKeySearch;
        }
    } else if ([textField isEqual:self.destinationTextField]) {
        if ([self.originTextField.text isEqualToString:@""]) {
            textField.returnKeyType = UIReturnKeyNext;
        } else {
            textField.returnKeyType = UIReturnKeySearch;
        }
    }
}

- (void)originTextFieldDidChange:(UITextField *)textField {
    [Bridge sharedInstance].routeViewFetchSearchData(textField.text);
    [self visibleMenuWithText:textField.text];
}

- (void)destinationTextFieldDidChange:(UITextField *)textField {
    [Bridge sharedInstance].routeViewFetchSearchData(textField.text);
    [self visibleMenuWithText:textField.text];
}

- (void)originTextFieldDidEndOnExit:(UITextField *)textField {
    if (!self.destinationTextField.text || [self.destinationTextField.text isEqualToString:@""]) {
        self.destinationTextField.returnKeyType = UIReturnKeySearch;
        [self.destinationTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
}

- (void)destinationTextFieldDidEndOnExit:(UITextField *)textField {
    if (!self.originTextField.text || [self.originTextField.text isEqualToString:@""]) {
        self.originTextField.returnKeyType = UIReturnKeySearch;
        [self.originTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *origin = self.originTextField.text;
    NSString *destination = self.destinationTextField.text;
    if (![origin isEqualToString:@""] && ![destination isEqualToString:@""]) {
        [Bridge sharedInstance].removeTrackingLayerGeometry(@"Route");
        [Bridge sharedInstance].removeTrackingLayerGeometry(@"Landmark");
        [self downloadRouteDataWithOrigin:origin destination:destination];
    }
    return YES;
}

@end
