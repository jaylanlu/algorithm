//
//  ViewController.m
//  runtime
//
//  Created by Jaylan on 2018/11/1.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+DefaultColor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] init];
    label.defaultColor = [UIColor redColor];
    [label updateColor];
    [UILabel update];
    NSLog(@"label-%@",label.defaultColor);
}


@end
