//
//  SecondViewController.m
//  NotificationCenter
//
//  Created by Jaylan on 2019/1/21.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
/**
 strong修饰和copy修饰的对于存在可变形类型的区别
 */
@property (nonatomic, strong) NSString *str_strong;
@property (nonatomic, copy) NSString *str_copy;

@property (nonatomic, strong) NSMutableString *mstr_strong;
@property (nonatomic, copy) NSMutableString *mstr_copy;


@property (nonatomic, strong) NSString *strongStr;
@property (nonatomic, weak) NSString *weakStr;
@property (nonatomic, assign) NSString *assignStr;
@property (nonatomic, copy) NSString *cpStr;

@property (nonatomic, assign) NSString * flag;



@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __unused __unsafe_unretained NSString *str = [self func7];
    __unused NSInteger count = str.retainCount;
}

- (NSString *)func7 {
    NSMutableString *strM = [[NSMutableString alloc] initWithString:@"strValue"];
    NSLog(@"strM值地址：%p--strM值：%@--strM值引用计数：%@",strM,strM,[strM valueForKey:@"retainCount"]);//strM值地址：0x600001ab5bc0--strM值：strValue--strM值引用计数：1
    self.strongStr = strM;
    NSLog(@"strM值引用计数：%@",[strM valueForKey:@"retainCount"]);//strM值引用计数：2
    self.weakStr = strM;
    self.assignStr = strM;
    self.cpStr = strM;
//    NSLog(@"%p-%p-%p-%p-%p",strM,self.weakStr,self.assignStr,self.strongStr,self.cpStr);//0x600000969e90-0x600000969e90-0x600000969e90-0x600000969e90-0xcc8bd2833e56ff1c
    NSLog(@"strM值引用计数：%@",[strM valueForKey:@"retainCount"]);//strM值引用计数：2
//    self.strongStr = nil;
    NSLog(@"strM值引用计数：%@",[strM valueForKey:@"retainCount"]);//strM值引用计数：1
    [strM release];
    [self.strongStr release];
    //崩溃EXC_BAD_ACCESS (code=EXC_I386_GPFLT),原因是assign访问了一个不属于你的的内存
    //    NSLog(@"weak:%p---assign:%p----copy:%p",self.weakStr,self.assignStr,self.cpStr);
    
    //控制台打印出来的结果
    //    (lldb) p self.weakStr
    //    (NSString *) $0 = nil
    //    (lldb) p self.strongStr
    //    (NSString *) $1 = nil
    //    (lldb) p self.assignStr
    //    (NSString *) $2 = 0x000060000232f720//指针存在依旧指向原来的内存块，可对象已被释放
    
    NSString *stringMore10 = [[NSString alloc] initWithString:@"1234567891"];
    self.cpStr = stringMore10;
    NSLog(@"%x-%x", &stringMore10, &_cpStr);
    return strM;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)print
{
    self.weakStr;
//        NSLog(@"weak:%@---assign:%p----copy:%p",self.weakStr,self.assignStr,self.cpStr);
}
@end
