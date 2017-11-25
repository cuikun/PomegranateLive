//
//  LiveListLoactionModel.h
//  PomegranateLive
//
//  Created by CKK on 17/2/23.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "CommonModel.h"

@interface LiveListLoactionModel : CommonModel

@property (nonatomic,strong) NSString * pid;
@property (nonatomic,strong) NSString * ptitle;
@property (nonatomic,strong) NSMutableArray * roomList;
@property (nonatomic,strong) NSMutableArray * provinceNumAry;

@end

@interface ProvinceNumModel : CommonModel

@property (nonatomic,strong) NSString * pid;
@property (nonatomic,strong) NSString * ptitle;

@end
