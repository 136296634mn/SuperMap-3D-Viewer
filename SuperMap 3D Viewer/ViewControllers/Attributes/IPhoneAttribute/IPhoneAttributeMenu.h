//
//  IPhoneAttributeMenu.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/26.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPhoneAttributeMenu : UIWindow

@property (copy, nonatomic) void (^resignEvent)();

+ (IPhoneAttributeMenu *)sharedInstance;
- (void)showWithData:(id)data;

@end
