//
//  SMFeature3D.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/21.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Feature3D;
@interface SMFeature3D : NSObject

@property (strong, nonatomic) Feature3D *feature3D;
@property (assign, nonatomic) BOOL favorable;

@end
