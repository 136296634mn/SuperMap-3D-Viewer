//
//  HttpDownload.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/22.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "HttpDownload.h"
#import "HttpSession.h"
#import "SearchResultsModel.h"
#import "AttributeModel.h"

@implementation HttpDownload

/*
 **  SearchData
 **  baseURL http://www.supermapol.com/iserver/services/localsearch/rest/searchdatas/China/poiinfos.json
 **  suffixURL keywords=%@&location=&radius=&leftLocation=&rightLocation=&pageSize=50&pageNum=1&callback=loadJsonp483369
 */

/*
 **  address = "\U5317\U4eac\U5e02\U671d\U9633\U533a";
 location =             {
 x = "116.5163108937985";
 y = "40.0016976742206";
 };
 name = "\U5357\U768b";
 score = 0;
 telephone = "<null>";
 uid = 07f3c8b55c5918606240a928;
 */

+ (void)downloadSearchDataWithKeywords:(NSString *)keywords
                               success:(void (^)(id items))success
                               failure:(void (^)(HttpDownloadErrorType errorType))failure {
    NSString *baseURL = @"http://www.supermapol.com/iserver/services/localsearch/rest/searchdatas/China/poiinfos.json?";
    NSString *suffixURL = [NSString stringWithFormat:@"keywords=%@&location=&radius=&leftLocation=&rightLocation=&pageSize=50&pageNum=1&callback=loadJsonp483369", keywords];
    suffixURL = [suffixURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *URL = [baseURL stringByAppendingString:suffixURL];
    [HttpSession GET:URL
             success:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
                 NSArray *items = [responseObject objectForKey:@"poiInfos"];
                 NSMutableArray *models = [[NSMutableArray alloc] init];
                 [items enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                     SearchResultsModel *model = [SearchResultsModel modelWithDic:dic];
                     [models addObject:model];
                 }];
                 dispatch_async(dispatch_get_main_queue(), ^{// 返回主线程
                     success(models);
                 });
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
             }];
}

/*
**  baseURL http://www.supermapol.com/iserver/services/navigation/rest/navigationanalyst/China/pathanalystresults.rjson?
**  suffixURL  pathAnalystParameters=[{startPoint:{x:116.467524,y:39.914319},endPoint:{x:116.25814,y:40.666082},passPoints:null,routeType:MINLENGTH}]
*/

+ (void)downloadRouteDataWithKeywords:(NSString *)keywords
                              success:(void (^)(id items))success
                              failure:(void (^)(HttpDownloadErrorType errorType))failure {
    NSString *baseURL = @"http://www.supermapol.com/iserver/services/localsearch/rest/searchdatas/China/poiinfos.json?";
    NSString *suffixURL = [NSString stringWithFormat:@"keywords=%@&location=&radius=&leftLocation=&rightLocation=&pageSize=50&pageNum=1&callback=loadJsonp483369", keywords];
    suffixURL = [suffixURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *URL = [baseURL stringByAppendingString:suffixURL];
    [HttpSession GET:URL
             success:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
                 NSArray *items = [responseObject objectForKey:@"poiInfos"];
                 NSMutableArray *models = [[NSMutableArray alloc] init];
                 [items enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                     SearchResultsModel *model = [SearchResultsModel modelWithDic:dic];
                     [models addObject:model];
                 }];
                 success(models);
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
                 
             }];
}

+ (void)downloadRouteDataWithParameters:(NSDictionary *)parameters
                                success:(void (^)(id items))success
                                failure:(void (^)(HttpDownloadErrorType errorType))failure {
    NSDictionary *origin = parameters[@"origin"];
    NSDictionary *destination = parameters[@"destination"];
    NSString *baseURL = @"http://www.supermapol.com/iserver/services/navigation/rest/navigationanalyst/China/pathanalystresults.json?";
    NSString *suffixURL = [NSString stringWithFormat:@"pathAnalystParameters=[{startPoint:{x:%@,y:%@},endPoint:{x:%@,y:%@},passPoints:null,routeType:MINLENGTH}]", origin[@"x"], origin[@"y"], destination[@"x"], destination[@"y"]];
    suffixURL = [suffixURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *URL = [baseURL stringByAppendingString:suffixURL];
    [HttpSession GET:URL
             success:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
                 success(responseObject);
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
                 NSLog(@"%@", error);
             }];
}

+ (void)downloadRouteDataWithOrigin:(NSString *)origin
                        destination:(NSString *)destination
                            success:(void (^)(id items))success
                            failure:(void (^)(HttpDownloadErrorType errorType))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"origin" : @"",
                                                                                        @"destination" : @""}];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [self downloadRouteDataWithKeywords:origin
                                success:^(id items) {
                                    if ([items isKindOfClass:[NSArray class]] && ((NSArray *)items).count > 0) {
                                        SearchResultsModel *model = items[0];
                                        NSNumber *numberX = [NSNumber numberWithDouble:model.loca.x];
                                        NSNumber *numberY = [NSNumber numberWithDouble:model.loca.y];
                                        NSDictionary *origin = @{@"x" : numberX,
                                                                 @"y" : numberY};
                                        [parameters setObject:origin forKey:@"origin"];
                                    }
                                    dispatch_group_leave(group);
                                }
                                failure:^(HttpDownloadErrorType errorType) {
                                    dispatch_group_leave(group);
                                }];
    
    dispatch_group_enter(group);
    [self downloadRouteDataWithKeywords:destination
                                success:^(id items) {
                                    if ([items isKindOfClass:[NSArray class]] && ((NSArray *)items).count > 0) {
                                        SearchResultsModel *model = items[0];
                                        NSNumber *numberX = [NSNumber numberWithDouble:model.loca.x];
                                        NSNumber *numberY = [NSNumber numberWithDouble:model.loca.y];
                                        NSDictionary *destination = @{@"x" : numberX,
                                                                      @"y" : numberY};
                                        [parameters setObject:destination forKey:@"destination"];
                                    }
                                    dispatch_group_leave(group);
                                }
                                failure:^(HttpDownloadErrorType errorType) {
                                    dispatch_group_leave(group);
                                }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self downloadRouteDataWithParameters:parameters
                                      success:^(id items) {
                                          if ([items isKindOfClass:[NSArray class]] && ((NSArray *)items).count > 0) {
                                              NSDictionary *dic = items[0];
                                              NSMutableArray *pathPoints = [dic[@"pathPoints"] mutableCopy];
                                              NSDictionary *origin = parameters[@"origin"];
                                              NSDictionary *destination = parameters[@"destination"];
                                              [pathPoints insertObject:origin atIndex:0];
                                              [pathPoints addObject:destination];
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  success(pathPoints);
                                              });
                                          }
                                      }
                                      failure:^(HttpDownloadErrorType errorType) {
                                      }];
    });
}

/*
**  获取在线数据属性字段
**
*/

+ (void)downloadAttributeDataWithURL:(NSString *)URLString
                             success:(void (^)(id items))success
                             failure:(void (^)(HttpDownloadErrorType errorType))failure {
    [HttpSession GET:URLString
             success:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
                 NSArray *keys = [responseObject objectForKey:@"fieldNames"];
                 NSArray *values = [responseObject objectForKey:@"fieldValues"];
                 NSMutableArray *models = [[NSMutableArray alloc] init];
                 NSDictionary *dic = @{@"key" : @"ID",
                                       @"value" : [responseObject objectForKey:@"ID"]};
                 AttributeModel *model = [AttributeModel modelWithDic:dic];
                 [models addObject:model];
                 [keys enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     if (!([obj hasPrefix:@"SM"] || [obj hasPrefix:@"Sm"])) {
                         NSDictionary *dic = @{@"key" : obj,
                                               @"value" : values[idx]};
                         AttributeModel *model = [AttributeModel modelWithDic:dic];
                         [models addObject:model];
                     }
                 }];
                 dispatch_async(dispatch_get_main_queue(), ^{// 返回主线程
                     success(models);
                 });
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
             }];
}

@end
