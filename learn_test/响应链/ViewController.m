//
//  ViewController.m
//  响应链
//
//  Created by Jaylan on 2018/10/30.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "ViewController.h"
#import "AView.h"
#import "BView.h"
#import "CView.h"
#import "DView.h"
#import "EView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet AView *aView;
@property (weak, nonatomic) IBOutlet BView *bView;
@property (weak, nonatomic) IBOutlet CView *cView;
@property (weak, nonatomic) IBOutlet DView *dView;
@property (weak, nonatomic) IBOutlet EView *eView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//打印
//    2018-10-30 21:54:44.312637+0800 响应链[33878:728092] CView touch begin
//    2018-10-30 21:54:44.313134+0800 响应链[33878:728092] BView
//    2018-10-30 21:54:44.313278+0800 响应链[33878:728092] AView
//    2018-10-30 21:54:44.313380+0800 响应链[33878:728092] UIView
//    2018-10-30 21:54:44.313468+0800 响应链[33878:728092] ViewController
//    2018-10-30 21:54:44.313551+0800 响应链[33878:728092] UIWindow
//    2018-10-30 21:54:44.313641+0800 响应链[33878:728092] UIApplication
//    2018-10-30 21:54:44.313757+0800 响应链[33878:728092] AppDelegate
//    2018-10-30 21:54:44.314414+0800 响应链[33878:728092] CView touch end
    
    
    /**
     添加了手势之后，上面的CView touch end 没有了 替换成了aView tap
     所以手势的优先级比视图的高
     */
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aTap)];
    [_aView addGestureRecognizer:aTap];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, 30)];
    btn.backgroundColor = [UIColor blueColor];
    //同时添加action和tap只响应了tap 所以手势比action的优先级高
//    [btn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
//    UITapGestureRecognizer *ap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    [btn addGestureRecognizer:ap];
    [_dView addSubview:btn];
    
    
    
    UITapGestureRecognizer *bTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bTap)];
    [_bView addGestureRecognizer:bTap];
    
    UITapGestureRecognizer *eTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eTap)];
    [_eView addGestureRecognizer:eTap];
}

- (void)aTap {
    NSLog(@"aView tap");
}

- (void)clickAction {
    NSLog(@"this is btn Action ");
}

- (void)bTap {
    NSLog(@"bView tap");
}

- (void)eTap {
    NSLog(@"eView tap");
}
/*
 替换了hitTest:withEvent:和pointInside:withEvent:两个方法后
 
 *1
2018-10-31 09:17:59.190488+0800 响应链[3181:4105266] 点在UIWindow里
2018-10-31 09:17:59.190677+0800 响应链[3181:4105266] 点在UIView里
2018-10-31 09:17:59.190751+0800 响应链[3181:4105266] 点在AView里
2018-10-31 09:17:59.190857+0800 响应链[3181:4105266] 点不在DView里
2018-10-31 09:17:59.190935+0800 响应链[3181:4105266] 点在BView里
2018-10-31 09:17:59.191004+0800 响应链[3181:4105266] 点在CView里
2018-10-31 09:17:59.191081+0800 响应链[3181:4105266] 命中的view:CView
 
 *2
2018-10-31 09:17:59.191193+0800 响应链[3181:4105266] 点在UIStatusBarWindow里
2018-10-31 09:17:59.191282+0800 响应链[3181:4105266] 点不在UIStatusBar_Modern里
2018-10-31 09:17:59.191355+0800 响应链[3181:4105266] 命中的view:UIStatusBarWindow
2018-10-31 09:17:59.191666+0800 响应链[3181:4105266] 点在UIWindow里
2018-10-31 09:17:59.191851+0800 响应链[3181:4105266] 点在UIView里
2018-10-31 09:17:59.192026+0800 响应链[3181:4105266] 点在AView里
2018-10-31 09:17:59.192107+0800 响应链[3181:4105266] 点不在DView里
2018-10-31 09:17:59.192198+0800 响应链[3181:4105266] 点在BView里
2018-10-31 09:17:59.192324+0800 响应链[3181:4105266] 点在CView里
2018-10-31 09:17:59.192468+0800 响应链[3181:4105266] 命中的view:CView

 *3
2018-10-31 09:17:59.193297+0800 响应链[3181:4105266] CView touch begin
2018-10-31 09:17:59.197586+0800 响应链[3181:4105266] BView
2018-10-31 09:17:59.197724+0800 响应链[3181:4105266] AView
2018-10-31 09:17:59.197803+0800 响应链[3181:4105266] UIView
2018-10-31 09:17:59.197900+0800 响应链[3181:4105266] ViewController
2018-10-31 09:17:59.197964+0800 响应链[3181:4105266] UIWindow
2018-10-31 09:17:59.198045+0800 响应链[3181:4105266] UIApplication
2018-10-31 09:17:59.198123+0800 响应链[3181:4105266] AppDelegate
2018-10-31 09:17:59.268672+0800 响应链[3181:4105266] aView tap
*/

@end
