//
//  LiveListNewRequest.m
//  PomegranateLive
//
//  Created by CKK on 17/2/20.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "LiveListNewRequest.h"


@implementation LiveListNewRequest

-(NSString *)interfaceName
{
    return @"getlivelistnew";
}

-(EnumRequestType)requestType
{
    return EnumRequestTypePost;
}

-(RequestCompletionSuccModel *)successWithTast:(NSURLSessionDataTask *)task ResponseObject:(id)responseObject
{
    NSDictionary * responseDict = (NSDictionary *)responseObject;
    RequestCompletionSuccModel * modelSucc = [[RequestCompletionSuccModel alloc]init];
    
    [responseDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"content"] && [obj isKindOfClass:[NSDictionary class]]) {
            [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:[self roomListKey]] && [obj isKindOfClass:[NSArray class]]) {
                    modelSucc.arrSuccModel = [CommonModel modelsOfClass:[LiveRoomInfoModel class] fromDictArray:obj];
                    *stop = YES;
                }
            }];
            *stop = YES;
        }
    }];
    return modelSucc;
}

-(RequestCompletionFailModel *)failureWithTast:(NSURLSessionDataTask *)task Error:(NSError *)error
{
    RequestCompletionFailModel * modelFail = [[RequestCompletionFailModel alloc]init];
    modelFail.errorCode = [NSString stringWithFormat:@"%ld",(long)error.code];
    modelFail.errorDescription = error.description;
    return modelFail;
}

#pragma mark - uitl
/**
 *  获取响应分类的信息列表的key值
 *
 *  @return roomListKey
 */
-(NSString *)roomListKey
{
    if ([[self dicParameter][@"type"] isEqualToString:@""]) {
        return @"roomList";
    }else{
        return [self dicParameter][@"type"];
    }
}

@end
