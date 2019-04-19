//
//  ViewController.m
//  Crash集锦
//
//  Created by Jaylan on 2019/4/15.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self func1];
}

- (void)func1 {
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [arr addObject:[NSNull null]];
//  [arr insertObject:nil atIndex:0];
    
    NSString *ss = nil;
    if ([ss isKindOfClass:[NSObject class]]) {
        NSLog(@"asdfsa");//不会执行
    }
    //所以nil 不是ObjectType类型
    /*NSArray(NSMutableArray)类型的所有api的参数为ObjectType类型的都不能传nil，因为nil不是该类型 */
    
    [arr addObject:@3];
    [arr addObject:@"afdasd"];
    for (id item in arr) {
        NSLog(@"--%@",item);
    }
    //通常我们要求数组具有相同的数据类型，但是oc里面的数组可以不同的数据类型
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"" forKey:nil];
    //和数组一样，字典的api的objectType参数也不能传nil
}


@end
