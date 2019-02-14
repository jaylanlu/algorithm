//
//  UIView+Responder.m
//  响应链
//
//  Created by Jaylan on 2018/10/30.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "UIView+Responder.h"
#import <objc/runtime.h>
#import "DView.h"
#import "CView.h"
#import "AView.h"
#import "BView.h"


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

        swizzling_exchangeMethod([UIView class], @selector(hitTest:withEvent:), @selector(ds_hitTest:withEvent:));
        swizzling_exchangeMethod([UIView class], @selector(pointInside:withEvent:), @selector(ds_pointInside:withEvent:));
    });
}

#pragma mark-- 视图替换的方法
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

//模拟
- (UIView *)ds_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha < 0.01) {
        return  nil;
    }

    CGRect touch = self.bounds;
//    if ([self isKindOfClass:CView.class]) {
//        touch = CGRectInset(self.bounds, -30, -30);//都可以增大响应面积
//    }

    if ([self pointInside:point withEvent:event]) {////CGRectContainsPoint(touch, point)
        //逆序遍历，在subViews后面的先
        for (UIView *subView in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subView convertPoint:point fromView:self];

            UIView *hitTestView = [subView hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                 //在这里打印self.class可以看到递归返回的顺序
                return hitTestView;
            }

        }
        //这里就是该视图没有子视图了 点在该视图中，所以直接返回本身，上面的hitTestView就是这个。
        NSLog(@"命中的view:%@",self.class);
        return self;
    }
    return nil;//点不在本视图中
}

- (BOOL)ds_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect touchRect = self.bounds;
//    if ([self isKindOfClass:DView.class]) {
//        touchRect = CGRectInset(self.bounds, -30, -30);//增加view的响应面积
//    }
    BOOL success = CGRectContainsPoint(touchRect, point);
    if (success) {
        NSLog(@"点在%@里",self.class);
    }else {
        NSLog(@"点不在%@里",self.class);
    }
    return success;
}

@end
