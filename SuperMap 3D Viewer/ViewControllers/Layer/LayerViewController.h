//
//  LayerViewController.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/12.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Scene;
@interface LayerViewController : UIViewController

@property (copy, nonatomic) NSString *currentTitle;
@property (strong, nonatomic) Scene *currentScene;

@end
