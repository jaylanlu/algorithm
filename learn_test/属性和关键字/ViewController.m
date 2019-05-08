//
//  ViewController.m
//  Property&Keyword
//
//  Created by Jaylan on 2018/10/17.
//  Copyright © 2018年 Jaylan. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Stt.h"
#import "FirstViewController.h"
#import "viewDelegate.h"

@interface ViewController ()<viewDelegate>{
    BOOL _finished;
    BOOL isShow;
    NSString * title;
    //    BOOL _ggfinished;//这行代码存不存在不重要，下面合取的时候会自动生成
    NSMutableString *thirdName;
}

/**
 get、set以及@synthesize、@dynamic相关
 */
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *secondName;
@property (nonatomic, strong) NSMutableString *thirdName;
@property (nonatomic, strong, readonly) NSString *fourthName;
@property (nonatomic, assign, getter=isFinished, setter=finished:) BOOL finished;//编译器生成的get函数是isFinished,可以用self.isFinished访问该属性;self.isFinished和self.finished指向的地址是相同的
@property (nonatomic, strong, getter=getModel) NSString *str;
@property (nonatomic, strong) NSString * string;
@property (nonatomic, strong) NSString * sts;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) NSString *title;
@property (strong) NSString *as;
@property (nonatomic, strong) NSString *aas;

@end


@implementation ViewController
@dynamic firstName;
@synthesize secondName = _secondName;
@synthesize fourthName = _fourthName;

//@synthesize finished = _ggfinished;//finished的set方法会操作_ggfinished（这儿会自动生成成员变量_ggfinished）
@synthesize str = _gstr;//如果不存在@synthesize关键字，相当于@synthesize给每个属性都添加了合取（如string的就是：@synthesize string = _string）
@dynamic string;//编译器不会自动合取string的get和set方法,并且也不会生成_string成员变量，不能用_string访问
@synthesize sts;//不会生成成员变量_sts(生成的是成员变量sts),但是可以用sts 访问属性，并且sts的和self.sts相同
//@synthesize as;
- (void)viewDidLoad {
    [super viewDidLoad];
    /* 测试@dynamic的作用，缺乏getter和setter方法
     [self dynamicTest];
     */
    
    /*默认和@synthesize的作用
    [self synthesizeTest];
     */
    
    _finished = YES;
    NSLog(@"%p",self.isFinished);
    NSLog(@"%p-%p",self.finished,_finished);

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, 40, 30)];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(firstViewController) forControlEvents:UIControlEventTouchUpInside];
//     [self func1];
    
    _thirdName = @"sdfas";
//    [_thirdName appendFormat:@"af"];//崩溃，传入的是NSString类型
}

- (void)setSecondName:(NSString *)secondName {
    _secondName = secondName;
}

- (NSString*)secondName {
    return _secondName;
}

- (NSString *)fourthName {
    return _fourthName; //没有合成成员变量，不识别
}

- (BOOL)isFinished {
    return _finished;
}

- (void)finished:(BOOL)finished {
    
}



- (void)dynamicTest {
    self.firstName = @"";//!崩溃 -[ViewController setFirstName:]: unrecognized selector sent to instance 0x7fce2a204ff0
    NSString *a = self.firstName;//!崩溃 -[ViewController firstName]: unrecognized selector sent to instance 0x7fe7d3d0ff20
    NSLog(@"%@",a);
}


- (void)synthesizeTest {
    //默认情况下（@synthesize secondName = _secondName）,_secondName和self.secondName所指向的对象相同（地址相同）
    _secondName = @"";
    NSLog(@"%p---%p",_secondName,self.secondName);//0x0---0x0
    //    _secondName = @"";//不会调用setter方法
    //    self.secondName = @"";//会调用setter方法
    
    NSLog(@"-%p-%p-", self.thirdName,thirdName);//-0x0-0x0
    _thirdName = [NSMutableString stringWithFormat:@"afdsafs"];
    NSLog(@"%@-%p-%@-%p",self.thirdName,self.thirdName, thirdName,thirdName);
    NSString *aa = [NSString stringWithFormat:@"sdfas"];
    
    [aa llls];
    
    self.secondName  = @"";
}

- (void)firstViewController {
    FirstViewController *first = [FirstViewController new];
    [self presentViewController:first animated:YES completion:nil];
}

//+ (NSString *)sta {
//    return ViewController.sta;
//}
//
//+ (void)setSta:(NSString *)sta {
//    ViewController.sta = sta;
//}
//

/**
 get、set以及@synthesize、@dynamic相关测试
 */
- (void)func1 {
    
    //    ViewController.sta = @"lll";
    self.finished = YES;
    
    self.sts = [[NSMutableString alloc] initWithString:@""];
    NSLog(@"sts:%p--%p",self.sts,sts);
    
    //三个打印的内存地址是相同的标明三个指向的是同一个对象,并且值都改变了为1,retainCount = 1说明三个是同一个东西
    NSLog(@"isFinshed--%d--%p",self.isFinished,self.isFinished);
    NSLog(@"finsihed--%d--%p",self.finished,self.finished);
//    NSLog(@"ggfinished--%d--%p---%x",_ggfinished,_ggfinished,&_ggfinished);
    
    //字符串类型的结构是相同的,地址相同
    self.str = @"hhh";
    NSLog(@"getModel--%@--%p",self.getModel,self.getModel);
    NSLog(@"_gstr--%@--%p",_gstr,_gstr);
    NSLog(@"str--%@--%p",self.str,self.str);
    
    //    self.string = @"";//会崩溃，因为么有找到set方法；
    
    //只会生成方法声明
    NSLog(@"%@",self.str.a);
    self.str.a = @"afdsa";
    
    
}

//- (NSString *)as {
//    return _as;
//}
//
//- (void)setAs:(NSString *)as {
//
//}

//- (NSString *)aas {
//    return _as;
//}
//
//- (void)setAas:(NSString *)aas {
//
//}
@end
