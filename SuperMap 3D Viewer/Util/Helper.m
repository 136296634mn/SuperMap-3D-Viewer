//
//  Helper.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/11.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "Helper.h"

@implementation Helper

//  color
UIColor *GetColor(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

//  image
+ (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);//    size是想要设置成的大小
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}

//  measure unit conversion
+ (NSString *)unitConversionWithDistance:(double)distance {
    NSString *text = nil;
    if (distance < 10000) {
        text = [NSString stringWithFormat:@"%.2f米", distance];
    } else {
        text = [NSString stringWithFormat:@"%.2f千米", distance / 10000];
    }
    return text;
}

+ (NSString *)unitConversionWithArea:(double)area {
    NSString *text = nil;
    if (area < 1000000) {
        text = [NSString stringWithFormat:@"%.2f平方米", area];
    } else {
        text = [NSString stringWithFormat:@"%.2f平方千米", area / 1000000];
    }
    return text;
}

@end
