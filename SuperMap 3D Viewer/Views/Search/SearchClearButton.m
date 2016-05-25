//
//  SearchClearButton.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/21.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SearchClearButton.h"

@implementation SearchClearButton

- (void)drawRect:(CGRect)rect {
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = 8;
    
    UIBezierPath *roundPath = [UIBezierPath bezierPath];
    [roundPath addArcWithCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [[UIColor darkGrayColor] setFill];
    [roundPath fill];
    
    CGFloat translation = radius * sqrt(2) / 2 - 2;
    UIBezierPath *crossPath = [UIBezierPath bezierPath];
    [crossPath moveToPoint:CGPointMake(center.x - translation, center.y - translation)];
    [crossPath addLineToPoint:CGPointMake(center.x + translation, center.y + translation)];
    [crossPath moveToPoint:CGPointMake(center.x + translation, center.y - translation)];
    [crossPath addLineToPoint:CGPointMake(center.x - translation, center.y + translation)];
    [[UIColor lightGrayColor] setStroke];
    [crossPath stroke];
    [crossPath setLineCapStyle:kCGLineCapRound];
}

@end
