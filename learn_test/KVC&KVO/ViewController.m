//
//  ViewController.m
//  KVO
//
//  Created by Jaylan on 2018/10/26.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
<<<<<<< HEAD
#import "Address.h"
=======
#import "ViewController01.h"
>>>>>>> 378c1ee6a8bf196437fda8157e271b26b9b060df

@interface ViewController ()
@property (nonatomic, strong)ViewController01 *per;
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
<<<<<<< HEAD
    
//    NSNumber *nn = [person valueForKey:@"strr"];
//    NSLog(@"%@",nn);

//    add.city = @"武汉";//当city为私有时也可以
//    person.address = add;
    [person setValue:@"深圳" forKeyPath:@"address.city"];
=======
    NSNumber *nn = [person valueForKey:@"num"];
    NSLog(@"%@",nn);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(40, 80, 50, 40)];
    btn.userInteractionEnabled = YES;
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self.per action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
>>>>>>> 378c1ee6a8bf196437fda8157e271b26b9b060df
}

//- (void)tap{
//    NSLog(@"is tap");
//}

@end
