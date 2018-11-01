//
//  DView.m
//  响应链
//
//  Created by Jaylan on 2018/10/30.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "DView.h"

@implementation DView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)tapAction:(UIButton *)sender {
    NSLog(@"this is btn action");
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%@ touch begin", self.class);
//    UIResponder *next = [self nextResponder];
//    while (next) {
//        NSLog(@"%@",next.class);
//        next = [next nextResponder];
//    }
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%@ touch move",self.class);
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%@ touch end", self.class);
//}
//
//
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha < 0.01) {
//        return  nil;
//    }
//
//    if ([self pointInside:point withEvent:event]) {//[self pointInside:point withEvent:event]
//        //逆序遍历，在subViews后面的先
//        for (UIView *subView in [self.subviews reverseObjectEnumerator]) {
//            CGPoint convertedPoint = [subView convertPoint:point fromView:self];
//
//            UIView *hitTestView = [subView hitTest:convertedPoint withEvent:event];
//            if (hitTestView) {
//                //在这里打印self.class可以看到递归返回的顺序
//                return hitTestView;
//            }
//
//        }
//        //这里就是该视图没有子视图了 点在该视图中，所以直接返回本身，上面的hitTestView就是这个。
//        NSLog(@"命中的view:%@",self.class);
//        return self;
//    }
//    return nil;//返回nil后，在bview中返回本身这样无论是点击DView还是BView 都是BView响应
//}
//
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    CGRect touchRect = self.bounds;
//    if ([self isKindOfClass:DView.class]) {
//        touchRect = CGRectInset(self.bounds, -30, -30);//增加view的响应面积
//    }
//    BOOL success = CGRectContainsPoint(touchRect, point);
//    if (success) {
//        NSLog(@"点在%@里",self.class);
//    }else {
//        NSLog(@"点不在%@里",self.class);
//    }
//    return success;
//}

@end
