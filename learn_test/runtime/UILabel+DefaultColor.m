//
//  UILabel+DefaultColor.m
//  runtime
//
//  Created by Jaylan on 2018/11/1.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "UILabel+DefaultColor.h"
#import <objc/runtime.h>
/**
 关联对象，给分类增加属性
 */
static char kDefaultColorKey;//只有第一次能被初始化，或编译器自动赋值


@implementation UILabel (DefaultColor)

- (void)setDefaultColor:(UIColor *)defaultColor {
    objc_setAssociatedObject(self, &kDefaultColorKey, defaultColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSLog(@"--%s",&kDefaultColorKey);
}

- (UIColor *)defaultColor {
   return objc_getAssociatedObject(self, &kDefaultColorKey);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(updateColor)) {
        
        /**
         添加方法
         
         class_addMethod(Class _Nullable cls, SEL _Nonnull name, IMP _Nonnull imp, const char * _Nullable types)
         cls:被添加方法的类
         name: 被添加方法的名称的SEL
         imp:方法的实现
         types:方法的类型
         */
        class_addMethod(self.class, sel, class_getMethodImplementation(self.class, @selector(ds_updateColor)), nil);//"v@:"表示有参数
    }
    return [super resolveInstanceMethod:sel];
}

- (void)ds_updateColor {
    NSLog(@"this is updateColor");
}

- (void)ds_updateColor:(UIColor *)cr {
    NSLog(@"this is updateColor cr");
//    return nil;
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel == @selector(update)) {
        class_addMethod(object_getClass(self), sel, class_getMethodImplementation(object_getClass(self), @selector(update)), "v");
    }
    
    return [super resolveClassMethod:sel];
}

+ (void)update {
    NSLog(@"this is update");
}
@end
