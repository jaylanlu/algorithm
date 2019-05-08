//
//  SuperClass.m
//  category
//
//  Created by Jaylan on 2019/4/24.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import "SuperClass.h"

@implementation SuperClass

+ (void)load {
    NSLog(@"---%@",self);
}



- (void)print {
    NSLog(@"--%@",[self class]);
}


@end
