//
//  ViewController.m
//  KVO
//
//  Created by Jaylan on 2018/10/26.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "ViewController01.h"

@interface ViewController ()
@property (nonatomic, strong)ViewController01 *per;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Person *person = [[Person alloc] init];
    //注释掉set方法，会发现赋值是成功的
    [person setValue:@"Davi" forKey:@"name"];
//
//    NSString *name = [person valueForKey:@"name"];
//    NSLog(@"%@",name);
    NSNumber *nn = [person valueForKey:@"num"];
    NSLog(@"%@",nn);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(40, 80, 50, 40)];
    btn.userInteractionEnabled = YES;
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self.per action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

//- (void)tap{
//    NSLog(@"is tap");
//}

@end
