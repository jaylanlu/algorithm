//
//  ViewController.m
//  runtime
//
//  Created by Jaylan on 2018/11/1.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+DefaultColor.h"
#import "objc/runtime.h"

static inline void swizziling_exchangeMethod(Class class, SEL originalSelector, SEL swizzileSelector) {
//   获取类的实例方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzleMethod = class_getInstanceMethod(class, swizzileSelector);
    
//    添加一个方法，并且将其实现与指定的sel相对应
    BOOL success = class_addMethod(class, originalSelector, class_getMethodImplementation(class, swizzileSelector), method_getTypeEncoding(swizzleMethod));
    if (success) {
        class_replaceMethod(class, swizzileSelector, class_getMethodImplementation(class, originalSelector), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
}

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] init];
    label.defaultColor = [UIColor redColor];
    [label updateColor];
    [UILabel update];
    NSLog(@"label-%@",label.defaultColor);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"this is viewWillAppear");
}

- (void)ds_viewWillAppear:(BOOL)animated {
    NSLog(@"this is ds_viewWillAppear");
}



/**
 类在初始装载时调用
 */
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //交换一次输出ds_,再次交换输出viewWillAppear
        swizziling_exchangeMethod(self, @selector(viewWillAppear:), @selector(ds_viewWillAppear:));
        swizziling_exchangeMethod(self, @selector(viewWillAppear:), @selector(ds_viewWillAppear:));
    });
}


@end
