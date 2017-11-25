//
//  LiveListLoactionModel.m
//  PomegranateLive
//
//  Created by CKK on 17/2/23.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "LiveListLoactionModel.h"

@implementation LiveListLoactionModel

@end

@implementation ProvinceNumModel

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    if ([key isEqualToString:@"title"]) {
        self.ptitle = value;
    }
}


@end