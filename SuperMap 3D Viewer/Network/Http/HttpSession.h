//
//  HttpSession.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/22.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpSession : NSObject

+ (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

@end
