//
//  Factory.m
//  DesignMode
//
//  Created by Jaylan on 2019/4/25.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import "Factory.h"


@implementation Factory
+ (id)getShape:(Class)className {
    NSObject<Shape> *obj = [[className alloc] init];
    return obj;
}
@end
