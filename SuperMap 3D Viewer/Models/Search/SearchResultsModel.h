//
//  SearchResultsModel.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/22.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct {
    double x;
    double y;
} Location;

@interface SearchResultsModel : NSObject <NSCoding>

@property (copy, nonatomic) NSString *address;
@property (assign, nonatomic) Location loca;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger score;
@property (copy, nonatomic) NSString *telephone;
@property (copy, nonatomic) NSString *uid;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (SearchResultsModel *)modelWithDic:(NSDictionary *)dic;

@end
