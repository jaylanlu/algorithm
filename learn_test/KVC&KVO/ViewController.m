//
//  ViewController.m
//  KVO
//
//  Created by Jaylan on 2018/10/26.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Address.h"
#import "ViewController01.h"
#import <objc/runtime.h>



@interface ViewController ()
@property (nonatomic, strong) ViewController01 *per;

@property (nonatomic, strong) Person *pp;

@property (nonatomic, strong) Person *person1;
@property (nonatomic, strong) Person *person2;
@property (nonatomic, assign) NSInteger idx;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Address *add = [[Address alloc] init];
    Person *person = [[Person alloc] initWith:add];//address私有也可以
    //注释掉set方法，会发现赋值是成功的
    [person setValue:@"Davi" forKey:@"name"];
//
//    NSString *name = [person valueForKey:@"name"];
//    NSLog(@"%@",name);

    
//    NSNumber *nn = [person valueForKey:@"strr"];
//    NSLog(@"%@",nn);

//    add.city = @"武汉";//当city为私有时也可以
//    person.address = add;

    [person setValue:@"深圳" forKeyPath:@"address.city"];

    NSNumber *nn = [person valueForKey:@"num"];
    NSLog(@"%@",nn);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(40, 80, 50, 40)];
    btn.userInteractionEnabled = YES;
    [btn setBackgroundColor:[UIColor redColor]];
    self.pp = [Person new];
    [btn addTarget:_pp action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];


//    [person setValue:@"深圳" forKeyPath:@"address.city"];
//
//    NSNumber *nn = [person valueForKey:@"num"];
//    NSLog(@"%@",nn);
    
    self.person1 = [Person new];
    self.person2 = [Person new];
    self.person1.age = self.person2.age = 5;
    
    //打印方法的实现,会发现person1的setAge：方法的实现的地址变了
    NSLog(@"监听之前--person1:%p,--person2:%p",[self.person1 methodForSelector:@selector(setAge:)],[self.person2 methodForSelector:@selector(setAge:)]);
    //前后打印相同，应该是NSKVONotifying_Person类重写了class方法
    NSLog(@"%@--%@",[self.person1 class],[self.person2 class]);
    //执行这一句后self.person1.isa指向由Person变成NSKVONotifying_PersonP
//    [self.person1 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    //把地址强转IMP打印出来后
    /**
     (lldb) p (IMP)0x10d634552
     (IMP) $0 = 0x000000010d634552 (Foundation`_NSSetUnsignedLongLongValueAndNotify)
     (lldb) p (IMP)0x10d2d9150
     (IMP) $1 = 0x000000010d2d9150 (KVC&KVO`-[Person setAge:] at Person.h:17)
     可以看出person2的setAge:没有发生变化，而person1变成了_NSSetUnsignedLongLongValueAndNotify的C函数
     */
    NSLog(@"监听之后--person1:%p,--person2:%p",[self.person1 methodForSelector:@selector(setAge:)],[self.person2 methodForSelector:@selector(setAge:)]);
    
    //也可以这样打印所对应的类对象
    NSLog(@"claseObject-%s--%s",object_getClassName(self.person1),object_getClassName(self.person2));
    NSLog(@"%@--%@",[self.person1 class],[self.person2 class]);
    
//    2018-10-30 20:31:33.586610+0800 KVC&KVO[31665:677189] 方法名---setAge:
//    2018-10-30 20:31:33.586797+0800 KVC&KVO[31665:677189] 方法名---class
//    2018-10-30 20:31:33.586934+0800 KVC&KVO[31665:677189] 方法名---dealloc
//    2018-10-30 20:31:33.587038+0800 KVC&KVO[31665:677189] 方法名---_isKVOA
    [self printMethodNamesOfClass:object_getClass(self.person1)];
    
    
    //手动触发
    self.idx = 0;
    [self addObserver:self forKeyPath:@"idx" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self willChangeValueForKey:@"idx"];
    [self didChangeValueForKey:@"idx"];
    

}
- (IBAction)clickAction:(UIButton *)sender {
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.person1.age = self.person2.age = 10;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    (lldb) po self.person1.isa
//    NSKVONotifying_Person
//
//    Fix-it applied, fixed expression was:
//    self.person1->isa
//    (lldb) po self.person2.isa
//    Person
//
//    Fix-it applied, fixed expression was:
//    self.person2->isa
//上面是person1、person2分别打印出来的isa 可以看出isa指向NSKVONotifying_Person
    if ([keyPath isEqualToString:@"age"]) {
        NSLog(@"dic--%@",change);
    }
    //手动触发
    if ([keyPath isEqualToString:@"idx"]) {
        NSLog(@"dicc --%@",change);
    }
}


//打印一个类所有的方法名
- (void)printMethodNamesOfClass:(Class)cls {
    unsigned int cout;
    Method *metodList = class_copyMethodList(cls, &cout);
    for (int i = 0; i<cout; i++) {
        Method method = metodList[i];
        NSString *methodName = NSStringFromSelector(method_getName(method));
        NSLog(@"方法名---%@",methodName);
    }
    free(metodList);
}
@end
