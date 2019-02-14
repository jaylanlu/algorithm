//
//  ViewController.m
//  SD&AFN
//
//  Created by Jaylan on 2018/9/18.
//  Copyright © 2018年 Jaylan. All rights reserved.
//

#import "ViewController.h"
//#import "SD"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 80, 300, 400)];
    button.backgroundColor = [UIColor blueColor];
    [self.view addSubview:button];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
