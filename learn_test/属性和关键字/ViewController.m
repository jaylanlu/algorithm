//
//  ViewController.m
//  Property&Keyword
//
//  Created by Jaylan on 2018/10/17.
//  Copyright © 2018年 Jaylan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    BOOL _finished;
//    BOOL _ggfinished;//这行代码存不存在不重要，下面合取的时候会自动生成
}

/**
 get、set以及@synthesize、@dynamic相关
 */
@property (nonatomic, assign, getter=isFinished) BOOL finished;//编译器生成的get函数是isFinished,可以用self.isFinished访问该属性;self.isFinished和self.finished指向的地址是相同的
@property (nonatomic, strong, getter=getModel) NSString *str;
@property (nonatomic, strong) NSString * string;



/**
 拷贝与可变、不可变之间的关系
 */
@property (nonatomic, copy) NSString *ss0;
@property (nonatomic, copy) NSArray *arr0;
@property (nonatomic, copy) NSSet *set0;

@property (nonatomic, copy) NSMutableString *ss1;
@property (nonatomic, copy) NSMutableArray *arr1;
@property (nonatomic, copy) NSMutableSet *set1;

@end

@implementation ViewController
@synthesize finished = _ggfinished;//finished的set方法会操作_ggfinished（这儿会自动生成成员变量_ggfinished）
@synthesize str = _gstr;//如果不存在@synthesize关键字，相当于@synthesize给每个属性都添加了合取（如string的就是：@synthesize string = _string）
@dynamic string;//编译器不会自动合取string的get和set方法,并且也不会生成_string成员变量，不能用_string访问



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self func1];
    [self func2];
}


/**
 get、set以及@synthesize、@dynamic相关测试
 */
- (void)func1 {
    self.finished = YES;
    
    //三个打印的内存地址是相同的标明三个指向的是同一个对象,并且值都改变了为1
    NSLog(@"isFinshed--%d--%p",self.isFinished,self.isFinished);
    NSLog(@"finsihed--%d--%p",self.finished,self.finished);
    NSLog(@"ggfinished--%d--%p---%x",_ggfinished,_ggfinished,&_ggfinished);
    
    //字符串类型的结构是相同的
    self.str = @"hhh";
    NSLog(@"getModel--%@--%p",self.getModel,self.getModel);
    NSLog(@"_gstr--%@--%p",_gstr,_gstr);
    NSLog(@"str--%@--%p",self.str,self.str);
    
    //    self.string = @"";//会崩溃，因为么有找到set方法；
}

- (void)func2 {
    self.ss0 = @"ss0";
    self.ss1 = @"ss1";
    //浅拷贝，地址一样
    id ss0_copy = [self.ss0 copy];
    id ss1_copy = [self.ss1 copy];
    NSLog(@"ss0---%p",self.ss0);
    NSLog(@"ss1---%p",self.ss1);
    
    ss0_copy = @"ss0_copy";
    ss1_copy = @"ss1_copy";
}






@end
