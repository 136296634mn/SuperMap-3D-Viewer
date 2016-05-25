//
//  HttpDownload.h
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/22.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HttpDownloadErrorType) {
    
};

@interface HttpDownload : NSObject

//  根据关键字下载搜索数据
+ (void)downloadSearchDataWithKeywords:(NSString *)keywords
                               success:(void (^)(id items))success
                               failure:(void (^)(HttpDownloadErrorType errorType))failure;

+ (void)downloadRouteDataWithOrigin:(NSString *)origin
                        destination:(NSString *)destination
                            success:(void (^)(id items))success
                            failure:(void (^)(HttpDownloadErrorType errorType))failure;

//  下载在线数据属性字段
+ (void)downloadAttributeDataWithURL:(NSString *)URLString
                             success:(void (^)(id items))success
                             failure:(void (^)(HttpDownloadErrorType errorType))failure;

@end
