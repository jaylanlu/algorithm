//
//  NSNull+NullSafe.m
//  runtime
//
//  Created by Jaylan on 2018/11/28.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "NSNull+NullSafe.h"
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

#ifndef NULLSAFE_ENDBLED
#define NULLSAFE_ENDBLED 1
#endif

#pragma GCC diagnostic ignored "-Wgnu-conditional-omitted-operand"

@implementation NSNull (NullSafe)

#if NULLSAFE_ENDBLED

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    @synchronized ([self class]) {
        NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
        if (!signature) {
            static NSMutableSet *classList = nil;
            static NSMutableDictionary *signatureCache;
            if (signatureCache == nil) {
                classList = [NSMutableSet new];
                signatureCache = [NSMutableDictionary new];
                
                //获取所有已注册的的类，
                int numClasses = objc_getClassList(NULL, 0);
                Class *classes = (Class *)malloc(sizeof(Class) * (unsigned long)numClasses);
                numClasses = objc_getClassList(classes, numClasses);
            }
        }
    }
}

#endif

@end
