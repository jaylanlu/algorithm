//
//  UIView+Responder.m
//  响应链
//
//  Created by Jaylan on 2018/10/30.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "UIView+Responder.h"
#import <objc/runtime.h>


static inline void swizzling_exchangeMethod(Class class,SEL originalSelector,SEL swizzlingSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzlingMethod = class_getInstanceMethod(class, swizzlingSelector);
    
    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
    if (success) {
        class_replaceMethod(class, swizzlingSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzlingMethod);
    }
}

@implementation UIView (Responder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([UIView class], @selector(touchesBegan:withEvent:), @selector(ds_touchesBegan:withEvent:));
        swizzling_exchangeMethod([UIView class],@selector(touchesMoved:withEvent:), @selector(ds_touchesMoved:withEvent:));
        swizzling_exchangeMethod([UIView class], @selector(touchesEnded:withEvent:), @selector(ds_touchesEnded:withEvent:));
    });
}

#pragma mark-- 替换的方法
- (void)ds_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@ touch begin", self.class);
    UIResponder *next = [self nextResponder];
    while (next) {
        NSLog(@"%@",next.class);
        next = [next nextResponder];
    }
}

- (void)ds_touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@ touch move",self.class);
}

- (void)ds_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@ touch end", self.class);
}

@end
