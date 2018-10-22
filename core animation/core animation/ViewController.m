//
//  ViewController.m
//  core animation
//
//  Created by Jaylan on 2018/10/22.
//  Copyright © 2018年 Jaylan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    view.backgroundColor = [UIColor whiteColor];
    view.center = self.view.center;
    [self.view addSubview:view];
    
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50, 50, 100, 100);
//    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    UIImage *image = [UIImage imageNamed:@"ico_shoucang_on_"];
    blueLayer.contents = (__bridge id)(image.CGImage);
    blueLayer.contentsGravity = kCAGravityCenter;
    [view.layer addSublayer:blueLayer];
}


@end
