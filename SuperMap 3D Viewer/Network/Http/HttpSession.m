//
//  HttpSession.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/22.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "HttpSession.h"

@implementation HttpSession

+ (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = nil;
    task = [session dataTaskWithRequest:request
                      completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                          if (error) {
                              failure(task, error);
                          } else {
                              NSError *err = nil;
                              id responseJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&err];
                              if (err) {
                                  failure(task, err);
                              } else {
                                  success(task, responseJSON);
                              }
                          }
                      }];
    [task resume];
    return task;
}

@end
