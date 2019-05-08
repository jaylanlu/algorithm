//
//  ViewController.m
//  category
//
//  Created by Jaylan on 2019/3/17.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import "ViewController.h"
#import "SuperClass.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *string = @"甘斌是傻叉，大傻叉";
    NSString *s = [string substringFromIndex:5];
    SuperClass *superC = [[SuperClass alloc] init];
    [superC print];
    
}


@end
