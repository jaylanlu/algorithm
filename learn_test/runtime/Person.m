//
//  Person.m
//  runtime
//
//  Created by Jaylan on 2018/11/5.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

@interface Person()<NSCoding>
@end

@implementation Person
//解码
- (instancetype)initWithCoder:(NSCoder *)coder
{
    Class cls = self.class;
    while (cls != NSObject.class) {
        BOOL kIsSelfClass = cls == self.class;
        unsigned int ivarCount = 0;
        unsigned int propVarCount = 0;
        unsigned int shareVarCount = 0;
        
        Ivar *ivars = kIsSelfClass ? class_copyIvarList(cls, &ivarCount) : NULL;
        objc_property_t *propList = kIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);
        shareVarCount = ivarCount + propVarCount;
        for (NSInteger idx = 0; idx<shareVarCount; idx ++) {
            const char *varName = kIsSelfClass ? ivar_getName(*(ivars + idx)) : property_getName(*(propList + idx));
            NSString *key = [NSString stringWithUTF8String:varName];
            
            id value = [coder decodeObjectForKey:key];
            NSArray *filter = @[@"superclass",@"description",@"debugDescription",@"hash"];
            if (value && [filter containsObject:key] == NO) {
                [self setValue:value forKey:key];
                
            }
        }
        free(ivars);
        free(propList);
        cls = class_getSuperclass(cls);
    }
    return self;
}

//编码
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
    Class cls = self.class;
    while (cls != NSObject.class) {
        BOOL kIsSelfClass = cls == self.class;
        unsigned int ivarCount = 0;
        unsigned int propVarCount = 0;
        unsigned int shareVarCount = 0;
        
        Ivar *ivars = kIsSelfClass ? class_copyIvarList(cls, &ivarCount) : NULL;
        objc_property_t *propList = kIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);
        shareVarCount = ivarCount + propVarCount;
        for (NSInteger idx = 0; idx<shareVarCount; idx ++) {
            const char * varName = kIsSelfClass ? ivar_getName(*(ivars + idx)) : property_getName(*(propList + idx));
            NSString *key = [NSString stringWithUTF8String:varName];
            
            id value = [self valueForKey:key];
            NSArray *filter = @[@"superclass",@"description",@"debugDescription",@"hash"];
            if (value && [filter containsObject:key] == NO) {
                [aCoder encodeObject:value forKey:key];
            }
        }
        free(ivars);
        free(propList);
        cls = class_getSuperclass(cls);//指向当前类的父类
    }
    
}

//- (void)updateColor{
//    NSLog(@"update of person");
//}

@end
