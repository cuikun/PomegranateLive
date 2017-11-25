//
//  CommonModel.h
//  PomegranateLive
//
//  Created by CKK on 17/2/17.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonModel : NSObject

/**
 *  字典转化为model
 *
 *  @param arrDict 需要转化的字典
 *
 *  @return 目标model
 */

- (instancetype)initWithDictionary:(NSDictionary *) dict;

/**
 *  把字典数组 arrDict 转化为 modelClass 类的Model数组
 *
 *  @param modelClass modelClass
 *  @param arrDict    arrDict
 *
 *  @return model的数组
 */
+(NSMutableArray *)modelsOfClass:(Class)modelClass fromDictArray:(NSArray *)arrDict;
/**
 *  Model 转为 字典
 *
 *  @return 结果字典
 */
-(NSDictionary *)serializerDict;

@end
