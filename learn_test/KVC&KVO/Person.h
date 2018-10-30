//
//  Person.h
//  KVC&KVO
//
//  Created by Jaylan on 2018/10/26.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
//@property (nonatomic, strong) NSString *address;
- (instancetype)initWith:(Address *)address;
@end

NS_ASSUME_NONNULL_END
