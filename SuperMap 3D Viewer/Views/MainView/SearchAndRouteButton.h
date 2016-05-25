//
//  SearchAndRouteButton.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/26.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, SearchType) {
    SearchTypeNone      = 0,
    SearchTypeRoute     = 1 << 0,
    SearchTypeSearch    = 1 << 1,
};

@interface SearchAndRouteButton : UIView

@property (assign, nonatomic) SearchType type;
    
@end
