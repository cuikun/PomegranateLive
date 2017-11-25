//
//  CommonAFNManager.m
//  PomegranateLive
//
//  Created by CKK on 17/2/20.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "CommonAFNManager.h"
#import "CommonModel.h"

#define BASE_URL @"http://v.6.cn/coop/mobile/index.php?padapi=coop-mobile-%@.php"
#define DEFAULT_URL @"http://v.6.cn/coop/mobile/index.php"

@implementation CommonAFNManager

+(void)requestWithParameterObject:(id) parameterObject andSuccHandler:(RequestCompletionSuccHandler)succHandler failHandler:(RequestCompletionFailHandler) failHandler
{
    CommonAFNManager * commonAFNManager = [[self alloc]initWithParameterObject:parameterObject andSuccHandler:succHandler failHandler:failHandler];
    [commonAFNManager fireReqeust];
}

- (instancetype)initWithParameterObject:(id) parameterObject andSuccHandler:(RequestCompletionSuccHandler)succHandler failHandler:(RequestCompletionFailHandler) failHandler
{
    self = [super init];
    if (self) {
        self.parameterObject = parameterObject;
        self.succHandler = succHandler;
        self.failHandler = failHandler;
    }
    return self;
}

-(EnumRequestType)requestType
{
    return EnumRequestTypePost;
}

-(NSString *)interfaceName
{
    return nil;
}

-(NSString *)url
{
    return [self URLStringForInterfaceName:[self interfaceName]];
}

-(NSDictionary *)dicParameter
{
    if ([self.parameterObject isKindOfClass:[NSDictionary class]]) {
        return self.parameterObject;
    }else{
        return [(CommonModel *)self.parameterObject serializerDict];
    }
}

-(RequestCompletionSuccModel *)successWithTast:(NSURLSessionDataTask *) task ResponseObject:(id) responseObject
{
    RequestCompletionSuccModel * succModel = [[RequestCompletionSuccModel alloc]init];
    return succModel;
    
}

-(RequestCompletionFailModel *)failureWithTast:(NSURLSessionDataTask *) task Error:(NSError *) error
{
    RequestCompletionFailModel * failModel = [[RequestCompletionFailModel alloc]init];
    DEBUG_LOG(@"error:%@",error.description);
    return failModel;
}

-(void)fireReqeust
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        DEBUG_LOG(@"Request URL:%@ \nReqeust Dict:%@ \n networkReachabilityStatus:%ld",[self url],[self dicParameter],(long)[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus);
        RequestCompletionFailModel * failModel = [[RequestCompletionFailModel alloc]init];
        failModel.errorCode = kNetworkNotReachableErrorCode;
        failModel.errorDescription = kNetworkNotReachableErrorDescription;
        self.failHandler(failModel);
        return;
    }
    
    switch ([self requestType]) {
        case EnumRequestTypePost:
        {
            [self firePostReuqest];
        }
            break;
        case EnumRequestTypeGet:
        {
            [self fireGetReqeust];
        }
            break;
        default:
        {
            [self firePostReuqest];
        }
            break;
    }
}

-(void)fireGetReqeust
{
//    DEBUG_LOG(@"Request URL:%@ \nReqeust Dict:%@ \n",[self url],[self dicParameter]);
    [[AFHTTPSessionManager sharedClient] PLE_GET:[self url] parameters:[self dicParameter]  success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        DEBUG_LOG(@"%@%@",[task.currentRequest allHTTPHeaderFields],
        [(NSHTTPURLResponse *)task.response allHeaderFields]);
        self.succHandler([self successWithTast:task ResponseObject:responseObject]);
        //        DEBUG_LOG(@"responseObject:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        self.failHandler([self failureWithTast:task Error:error]);
        DEBUG_LOG(@"dicError:%@,errorCode:%ld,error:%@",[self dicParameter],error.code,error.description);
    }];
}


-(void)firePostReuqest
{
//    DEBUG_LOG(@"Request URL:%@ \nReqeust Dict:%@ \n",[self url],[self dicParameter]);
    [[AFHTTPSessionManager sharedClient] PLE_POST:[self url] parameters:[self dicParameter]  success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        DEBUG_LOG(@"%@%@",[task.currentRequest allHTTPHeaderFields],
                  [(NSHTTPURLResponse *)task.response allHeaderFields]);
        self.succHandler([self successWithTast:task ResponseObject:responseObject]);
        //        DEBUG_LOG(@"responseObject:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        self.failHandler([self failureWithTast:task Error:error]);
        DEBUG_LOG(@"dicError:%@,errorCode:%ld,error:%@",[self dicParameter],error.code,error.description);
    }];
}




-(NSString *)URLStringForInterfaceName:(NSString *)interfaceName
{
    if (interfaceName && interfaceName.length > 0) {
        return [NSString stringWithFormat:BASE_URL,interfaceName];
    }else{
        return DEFAULT_URL;
    }
}

@end



@implementation RequestCompletionSuccModel




@end

@implementation RequestCompletionFailModel




@end
