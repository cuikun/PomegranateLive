//
//  CommonAFNManager.h
//  PomegranateLive
//
//  Created by CKK on 17/2/20.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "PomegranateLive.h"
#import "AFHTTPSessionManager+PLExtension.h"
#import "AFNetworkReachabilityManager.h"

@class CommonAFNManager;
@class RequestCompletionSuccModel;
@class RequestCompletionFailModel;

typedef void (^RequestCompletionSuccHandler)(RequestCompletionSuccModel * succModel);
typedef void (^RequestCompletionFailHandler)(RequestCompletionFailModel * failModel);

typedef NS_ENUM(NSInteger,EnumRequestType)
{
    EnumRequestTypePost,
    EnumRequestTypeGet
};

@interface CommonAFNManager : NSObject
{
@protected
    RequestCompletionSuccHandler _succHandler;
    RequestCompletionFailHandler _failHandler;
    id _parameterObject;
}

@property (nonatomic, copy) RequestCompletionSuccHandler succHandler;
@property (nonatomic, copy) RequestCompletionFailHandler failHandler;
@property (nonatomic, strong) id parameterObject;


/**
 *  发送异步请求
 *
 *  @param parameterObject 请求参数（类型是字典或者是 CommonModel）
 *  @param succHandler     请求成功block
 *  @param failHandler     请求失败blick
 */
+(void)requestWithParameterObject:(id) parameterObject andSuccHandler:(RequestCompletionSuccHandler)succHandler failHandler:(RequestCompletionFailHandler) failHandler;

/**
 *  返回请求URL 例：http://v.6.cn/coop/mobile/index.php?padapi=coop-mobile-getlivelistnew.php
 *
 *  @return url
 */
-(NSString *)url;


/**
 *  返回请求URL名字 例：getlivelistnew
 *
 *  @return interfaceName
 */
-(NSString *)interfaceName;

/**
 *  请求的参数字典
 *
 *  @return dicParameter
 */
-(NSDictionary *)dicParameter;

/**
 *  请求类型
 *
 *  @return requestType
 */
-(EnumRequestType)requestType;

/**
 *  请求成功函数，解析在这里面做，
 *
 *  @param task           task
 *  @param responseObject responseObject
 */
-(RequestCompletionSuccModel *)successWithTast:(NSURLSessionDataTask *) task ResponseObject:(id) responseObject;

/**
 *  请求失败函数，函数请求失败在这里做
 *
 *  @param task           task
 *  @param responseObject error
 */
-(RequestCompletionFailModel *)failureWithTast:(NSURLSessionDataTask *) task Error:(NSError *) error;

@end


/**
 *
 *  RequestCompletion返回参数，扩展返回参数只需继承子类
 *
 */
#import "CommonModel.h"

@interface RequestCompletionSuccModel : CommonModel

@property (nonatomic,strong) NSMutableArray * arrSuccModel;

@end

@interface RequestCompletionFailModel : CommonModel

@property (nonatomic,strong) NSString * errorCode;
@property (nonatomic,strong) NSString * errorDescription;

@end





