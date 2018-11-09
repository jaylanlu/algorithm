//
//  Biology.m
//  runtime
//
//  Created by Jaylan on 2018/11/7.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "Biology.h"
#import <objc/runtime.h>

@implementation Biology

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        NSMutableArray * keys = [NSMutableArray new];
        NSMutableArray * attributes = [NSMutableArray new];
    
        unsigned int outCount;
        objc_property_t *propertyList = class_copyPropertyList(self.class, &outCount);
        for (NSInteger idx = 0; idx < outCount; idx++) {
            objc_property_t property = propertyList[idx];
            //获取属性名
            NSString *key = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            [keys addObject:key];
            
            //获取属性特性描述字符串 T@"NSString",C,N,V_key
//            属性类型  name值：T  value：变化
//            编码类型  name值：C(copy) &(strong) W(weak) 空(assign) 等 value：无
//            非/原子性 name值：空(atomic) N(Nonatomic)  value：无
//            变量名称  name值：V  value：变化

            NSString *attribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            [attributes addObject:attribute];
        }
        free(propertyList);
        
        for (NSString * key in keys) {
            if (![dict valueForKey:key]) {
                continue;
            }
            [self setValue:[dict valueForKey:key] forKey:key];
        }
    }
    return self;
}

@end
