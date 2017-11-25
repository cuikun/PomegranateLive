//
//  CommonModel.m
//  PomegranateLive
//
//  Created by CKK on 17/2/17.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "CommonModel.h"
#import <objc/runtime.h>

@implementation CommonModel

/**
 *  字典转化为model
 *
 *  @param arrDict 需要转化的字典
 *
 *  @return 目标model
 */
- (instancetype)initWithDictionary:(NSDictionary *) dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

/**
 *  把字典数组 arrDict 转化为 modelClass 类的Model数组
 *
 *  @param modelClass modelClass
 *  @param arrDict    arrDict
 *
 *  @return model的数组
 */
+(NSMutableArray *)modelsOfClass:(Class)modelClass fromDictArray:(NSArray *)arrDict
{
    NSMutableArray * arrModel = [[NSMutableArray alloc]init];
    for (NSDictionary * dict in arrDict) {
        [arrModel addObject:[[modelClass alloc]initWithDictionary:dict]];
    }
    return arrModel;
}

/**
 *  Model 转为 字典
 *
 *  @return 结果字典
 */
-(NSDictionary *)serializerDict
{
    NSMutableDictionary *dicUserModel = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(properties[i]);
        
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue) {
            [dicUserModel setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);

    return dicUserModel;
}

/**
 *  处理未定义的属性,防止未处理未定义崩溃
 *
 *  @param value 未定义的属性值
 *  @param key   未定义的属性名
 */
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

/**
 *  处理传过来的value类型不为string时
 *
 *  @param value value
 *  @param key   key
 */
-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([value isKindOfClass:[NSString class]]) {
        [super setValue:value forKey:key];
    }else{
        [super setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
    }
}

@end
