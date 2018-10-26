//
//  ViewController.m
//  KVO
//
//  Created by Jaylan on 2018/10/26.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Person *person = [[Person alloc] init];
    //注释掉set方法，会发现赋值是成功的
//    [person setValue:@"Davi" forKey:@"name"];
//
//    NSString *name = [person valueForKey:@"name"];
//    NSLog(@"%@",name);
    NSNumber *nn = [person valueForKey:@"num"];
    NSLog(@"%@",nn);
}

@end
