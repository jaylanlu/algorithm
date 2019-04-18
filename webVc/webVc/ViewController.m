//
//  ViewController.m
//  webVc
//
//  Created by Jaylan on 2019/4/16.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://activity.m.duiba.com.cn/chome/index?from=login&spm=59019.1.1.1"]]];
}


@end
