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


@interface ViewController ()
@property (nonatomic, strong) ViewController01 *per;
@property (nonatomic, strong) Person *pp;

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

}

//- (void)tap{
//    NSLog(@"is tap");
//}

@end
