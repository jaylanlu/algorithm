//
//  UILabel+DefaultColor.h
//  runtime
//
//  Created by Jaylan on 2018/11/1.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (DefaultColor)

@property (nonatomic, strong) UIColor *defaultColor;

- (void)updateColor;
+ (void)update;
@end

NS_ASSUME_NONNULL_END
