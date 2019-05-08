//
//  Factory.h
//  DesignMode
//
//  Created by Jaylan on 2019/4/25.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rectangle.h"
#import "Square.h"
#import "Circle.h"


NS_ASSUME_NONNULL_BEGIN

@interface Factory : NSObject

+ (id)getShape:(Class)className;
@end

NS_ASSUME_NONNULL_END
