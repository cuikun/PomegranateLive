//
//  AFHTTPSessionManager+PLExtension.m
//  PomegranateLive
//
//  Created by CKK on 17/2/20.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "AFHTTPSessionManager+PLExtension.h"


@implementation AFHTTPSessionManager (PLExtension)

+ (instancetype)sharedClient {
    static AFHTTPSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[[self class] alloc] initWithBaseURL:nil sessionConfiguration:nil];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    });
    return _sharedClient;
}

- (nullable NSURLSessionDataTask *)PLE_GET:(nullable NSString *)URLString
                                parameters:(nullable id)parameters
                                   success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                                   failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure
{
    
    return [self GET:URLString parameters:parameters progress:nil success:success failure:failure];
}


- (nullable NSURLSessionDataTask *)PLE_POST:(nonnull NSString *)URLString
                                 parameters:(nullable id)parameters
                                    success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                                    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure
{
    return [self POST:URLString parameters:parameters progress:nil success:success failure:failure];
}




@end
