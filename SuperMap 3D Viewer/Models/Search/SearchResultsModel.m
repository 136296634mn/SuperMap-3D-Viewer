//
//  SearchResultsModel.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/22.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "SearchResultsModel.h"
#import <SuperMap/SuperMap.h>

@implementation SearchResultsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"location"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)value;
            NSNumber *x = [dic objectForKey:@"x"];
            NSNumber *y = [dic objectForKey:@"y"];
            self.loca = {[x doubleValue], [y doubleValue]};
        }
    }
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (SearchResultsModel *)modelWithDic:(NSDictionary *)dic {
    SearchResultsModel *model = [[SearchResultsModel alloc] initWithDic:dic];
    return model;
}

#pragma mark -- NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSData *loca = [NSData dataWithBytes:&_loca length:sizeof(Location)];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:loca forKey:@"loca"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.score forKey:@"score"];
    [aCoder encodeObject:self.telephone forKey:@"telephone"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) return nil;
    
    self.address = [aDecoder decodeObjectForKey:@"address"];
    NSData *loca = [aDecoder decodeObjectForKey:@"loca"];
    Location temp;
    [loca getBytes:&temp];
    self.loca = temp;
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.score = [aDecoder decodeIntegerForKey:@"score"];
    self.telephone = [aDecoder decodeObjectForKey:@"telephone"];
    self.uid = [aDecoder decodeObjectForKey:@"uid"];
    
    return self;
}

@end
