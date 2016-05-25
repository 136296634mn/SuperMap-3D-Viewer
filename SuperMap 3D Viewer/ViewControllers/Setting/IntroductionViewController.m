//
//  IntroductionViewController.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/12.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "IntroductionViewController.h"
#import "Helper.h"
#import "NavigationItem.h"

@interface IntroductionViewController ()

@property (weak, nonatomic) IBOutlet NavigationItem *navigationItem;

@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = GetColor(241, 241, 241, 1.0);
    
    //  设置导航条属性
    [self.navigationItem setTitle:_currentTitle];
    [self.navigationItem setPopToPreviousViewController:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
