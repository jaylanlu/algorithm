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
@property (nonatomic, strong)NSDictionary * dic0;

@property (nonatomic, strong) NSMutableString *ss1;
@property (nonatomic, strong) NSMutableArray *arr1;
@property (nonatomic, copy) NSMutableSet *set1;
@property (nonatomic, strong)NSMutableDictionary *dic1;

@end

@implementation ViewController
@synthesize finished = _ggfinished;//finished的set方法会操作_ggfinished（这儿会自动生成成员变量_ggfinished）
@synthesize str = _gstr;//如果不存在@synthesize关键字，相当于@synthesize给每个属性都添加了合取（如string的就是：@synthesize string = _string）
@dynamic string;//编译器不会自动合取string的get和set方法,并且也不会生成_string成员变量，不能用_string访问



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self func1];
//    [self func2];
    [self func4];
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

//字符串和拷贝
- (void)func2 {
    //在运行到第一行和第二行的时候分别在控制台打印地址（p str和p &str）会发现p str打印的地址变了，而p &str打印的地址没变，从而可以知道p str打印的是指针所指对象的z地址，p &str打印的是指针变了的地址
    NSString *str = @"hello";//1
    str = @"world";//2
    
    self.ss0 = @"ss0";
    self.ss1 = [[NSMutableString alloc] initWithString:@"ss1"];
    //浅拷贝，地址一样
    id ss0_copy = [self.ss0 copy];
    NSLog(@"ss0---%p--%p",self.ss0,ss0_copy);//打印出来的效果和p self.ss0是相同的
    id ss0_sub = [ss0_copy substringFromIndex:1];
//    [ss0_copy appendString:@"_m"];//崩溃，生成的副本是不可变的
    
    //深拷贝，地址不同
    id ss1_copy = [self.ss1 copy];
    NSLog(@"ss1---%p--%p",self.ss1,ss1_copy);
//    [ss1_copy appendString:@"_m"];//崩溃，生成的副本是不可变的
    
    
    //深拷贝，ss0_mutableCopy 和self.ss0指向的对象不一样
    id ss0_mutableCopy = [self.ss0 mutableCopy];
    id ss1_mutableCopy = [self.ss1 mutableCopy];
    
    NSLog(@"ss0---%p--%p",self.ss0,ss0_mutableCopy);
    NSLog(@"ss1---%p--%p",self.ss1,ss1_mutableCopy);
    //下面两个都正常运行，表明生成的副本都是可变的
    [ss0_mutableCopy appendString:@"_m"];
    [ss1_mutableCopy appendString:@"_m"];
    
    //小结：对于字符串，只有不可变字符串的copy才是浅拷贝，其他都是深拷贝；copy生成的都是不可变字符串，mutableCopy生成的都是可变字符串
}

//数组和拷贝
- (void)func3 {
    //p 打印出来的地址相同，所以是浅拷贝
    self.arr0 = @[@1,@3,@5];
    id arr0_copy = [self.arr0 copy];
//    [arr0_copy addObject:@7];//崩溃，生成的副本是不可变的
    
    //p 打印出来的地址不同，说明指向首元素的指针地址是不同的，但打印首元素的地址是相同的,所以只是拷贝了首元素的指针，并没有拷贝内容
    self.arr1 = [[NSMutableArray alloc] initWithArray:self.arr0];
    id  arr1_copy = [self.arr1 copy];
//    [arr1_copy addObject:@9];//崩溃，生成的副本是不可变的
//    NSLog(@"arr1_copy---%p----%p",self.arr1.firstObject,arr1_copy.firstObject);
    
    //和arr1_copy情况相同，只是拷贝了首元素的指针，并没有拷贝内容
    id arr0_mutableCopy = [self.arr0 mutableCopy];
    [arr0_mutableCopy addObject:@7];//正常运行，生成的副本是可变的
    
    //和arr1_copy情况相同，只是拷贝了首元素的指针，并没有拷贝内容
    id arr1_mutalbeCopy = [self.arr1 mutableCopy];
    [arr1_mutalbeCopy addObject:@9];//正常运行，生成的副本是可变的
    
    
    //小结：严格的来说数组的所有拷贝都是浅拷贝，只有不可变数组的copy没有进行指针拷贝，其他的都只是进行了指针拷贝；copy生成的副本都是不可变的，mutableCopy生成的副本都是可变的，这个和字符串相同
}

- (void)func4 {
    //打印出来的地址相同，浅拷贝
    self.set0 = [[NSSet alloc] initWithObjects:@1,@2,@3, nil];
    id set0_copy = [self.set0 copy];
//    [set0_copy addObject:@4];//崩溃，副本是不可变的
    
    //打印出来的地址相同，浅拷贝
    self.set1 = [[NSMutableSet alloc] initWithObjects:@1,@2,@3, nil];
    id set1_copy = [self.set1 copy];
//    [set1_copy addObject:@5];//崩溃，副本是不可变的
    
    //打印出来的地址不同，但里面的每个元素的地址相同，没有做内容拷贝
    id set0_mutableCopy = [self.set0 mutableCopy];
    [set0_mutableCopy addObject:@6];//正常运行，副本是可变的
    id set1_mutableCopy = [self.set1 mutableCopy];
    [set1_mutableCopy addObject:@7];//正常运行，副本是可变的
}

- (void)func5 {
    //打印地址一样，浅拷贝
    self.dic0 = [[NSDictionary alloc] initWithObjectsAndKeys:
                 @1,@"key1",@2,@"key2", nil];
    id dic0_copy = [self.dic0 copy];
//    [dic0_copy setObject:@3 forKey:@"key3"];//崩溃，生成的对象是不可变的
    //打印地址不一样，里面数据的地址一样，没有拷贝内容
    self.dic1 = [[NSMutableDictionary alloc] initWithDictionary:_dic0];
    id dic1_copy = [self.dic0 copy];
//    [dic1_copy setObject:@3 forKey:@"key3"];//崩溃，生成的对象是不可变的
    
    //打印出来的地址不同，里面数据的地址一样，没有拷贝内容
    id dic0_mutable = [self.dic0 mutableCopy];
    [dic0_mutable setObject:@4 forKey:@"key4"];//正常运行，副本是可变的
    id dic1_mutable = [self.dic1 mutableCopy];
    [dic1_mutable setObject:@5 forKey:@"key5"];//正常运行，副本是可变的
    
    
}
@end
