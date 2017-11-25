//
//  AFHTTPSessionManager+PLExtension.h
//  PomegranateLive
//
//  Created by CKK on 17/2/20.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFHTTPSessionManager (PLExtension)

+ (nonnull instancetype)sharedClient;

- (nullable NSURLSessionDataTask *)PLE_GET:(nullable NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;


- (nullable NSURLSessionDataTask *)PLE_POST:(nonnull NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;


@end
