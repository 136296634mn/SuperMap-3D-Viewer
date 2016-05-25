//
//  Helper.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/11.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper : NSObject

UIColor *GetColor(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);
+ (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size;
+ (NSString *)unitConversionWithDistance:(double)distance;
+ (NSString *)unitConversionWithArea:(double)area;

@end
