//
//  LiveListLocationRequest.h
//  PomegranateLive
//
//  Created by CKK on 17/2/23.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "CommonAFNManager.h"
#import "PomegranateLive.h"

@interface LiveListLocationRequest : CommonAFNManager

@end

/**
 *  RequestCompletionSuccModel 扩展类
 *  继承实现多个参数的扩展
 */

@class ProvinceNumModel;

@interface LiveListLocationRequestSuccModel : RequestCompletionSuccModel

@property (nonatomic,strong) NSMutableArray<ProvinceNumModel *> * arrProvinceNumModel;
@property (nonatomic,strong) ProvinceNumModel * localProvinceNumModel;

@end
