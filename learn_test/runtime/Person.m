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
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        unsigned int count;
        Ivar *ivars = class_copyIvarList(self.class, &count);
        for (NSInteger idx = 0; idx<count; idx ++) {
            Ivar var = ivars[idx];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(var)];
            [self setValue:[coder decodeObjectForKey:key] forKey:key];
        }
        free(ivars);
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList(object_getClass(aCoder), &outCount);
    for (NSInteger idx = 0; idx<outCount; idx ++) {
        Ivar var = ivars[idx];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(var)];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }

}

@end
