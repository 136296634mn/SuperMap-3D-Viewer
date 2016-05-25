//
//  ZYDAttributeMenu.h
//  ZYDAttributeView
//
//  Created by zyd on 16/3/23.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYDAttributeMenu : UIWindow

+ (ZYDAttributeMenu *)sharedInstance;

- (void)showWithTitle:(NSString *)title;

@end
