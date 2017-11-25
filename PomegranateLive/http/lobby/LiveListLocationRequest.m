//
//  LiveListLocationRequest.m
//  PomegranateLive
//
//  Created by CKK on 17/2/23.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "LiveListLocationRequest.h"
#import "LiveRoomInfoModel.h"
#import "LiveListLoactionModel.h"

@implementation LiveListLocationRequest


-(NSString *)interfaceName
{
    return @"getlivelistlocation";
}

-(EnumRequestType)requestType
{
    return EnumRequestTypePost;
}

-(RequestCompletionSuccModel *)successWithTast:(NSURLSessionDataTask *)task ResponseObject:(id)responseObject
{
    NSDictionary * responseDict = (NSDictionary *)responseObject;
    LiveListLocationRequestSuccModel * modelSucc = [[LiveListLocationRequestSuccModel alloc]init];
    
    [responseDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"content"] && [obj isKindOfClass:[NSDictionary class]]) {
            modelSucc.localProvinceNumModel = [[ProvinceNumModel alloc]initWithDictionary:obj];
            [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:@"roomList"] && [obj isKindOfClass:[NSArray class]]) {
                    modelSucc.arrSuccModel = [CommonModel modelsOfClass:[LiveRoomInfoModel class] fromDictArray:obj];
                }
                if ([key isEqualToString:@"provinceNumAry"] && [obj isKindOfClass:[NSArray class]]) {
                    modelSucc.arrProvinceNumModel = [CommonModel modelsOfClass:[ProvinceNumModel class] fromDictArray:obj];
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

@end

@implementation LiveListLocationRequestSuccModel



@end
