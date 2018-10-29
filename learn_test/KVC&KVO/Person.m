//
//  Person.m
//  KVC&KVO
//
//  Created by Jaylan on 2018/10/26.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "Person.h"

@interface Person()

/**
 kvc 与数组
 */
@property (nonatomic, strong) NSMutableArray *arr;
@end

@implementation Person {
    //[person setValue:@"Davi" forKey:@"name"] 成员变量找的顺序
    //_name->_isName->name->isName
    NSString *name;
    NSString *isName;
    NSString *_name;
    NSString *_isName;
    
    NSString *toSetName;
    
    BOOL isShow;
//    NSInteger num;
}


//- (void)setName: (NSString *)name {
//    toSetName = name;
//}

//[person valueForKey:@"name"] getter方法系列查找的顺序是  因为该方法返回的是id类型，所以值类型最好封装成相关的对象类型，否则打印出来会发现是随机的值
//getName->name->isName
//- (NSString *)getName {
//    return toSetName;
//}

//- (NSString *)name {
//    return toSetName;
//}


//- (NSString *)isName {
//    return toSetName;
//}

- (NSInteger)countOfNum {
    return 10;
}

//NSString *nn = [person valueForKey:@"num"];会调用这个
- (NSNumber *)objectInNumAtIndex:(NSInteger)idx {
    return @3;
}



/**
 这是一个是否查找成员变量的开关
 1.当没有找到setName方法时，会先执行这个，如果返回NO就会执行2,否则会找成员变量
 2.当没有找到getter方法系列时，会先执行这个，如果返回NO就会执行1，否则会找成员变量
 在运行过程中可以在控制台中用expression returnValue = NO 来改变返回值，从而来验证第2条,其实这时候
 */
+ (BOOL)accessInstanceVariablesDirectly {
    BOOL returnValue = YES;
    
    return returnValue;
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"1---该key不存在--%@",key);
    return nil;
}


/**
 //下面两种情况会调用下面这个方法
 //1.若没有找个setName方法，并且returnValue返回NO时（不查找成员变量）
 //2.若没有找到setName方法，returnValue返回YES时，并且成员变量（_name,_isName,name,isName）都不存在时
 */
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"2---该key不存在--%@",key);
}



@end
