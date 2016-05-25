//
//  ZYDAttributeMenu.h
//  ZYDAttributeView
//
//  Created by zyd on 16/3/23.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYDAttributeMenu : UIWindow

@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) void (^callBackBlock)(NSString *text);

+ (ZYDAttributeMenu *)sharedInstance;
- (void)showWithTitle:(NSString *)title;

@end
