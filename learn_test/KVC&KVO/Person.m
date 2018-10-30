//
//  Person.m
//  KVC&KVO
//
//  Created by Jaylan on 2018/10/26.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "Person.h"
//#import "Address.h"//kvc中的keyPath

@interface Person()

@property (nonatomic, strong) Address *address;




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

- (instancetype)initWith:(Address *)address {
    if (self = [super init]) {
        _address = address;
    }
    return self;
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


/**
 若getter系列方法没有找到，KVC会查找countOf<key>objectIn<key>AtIndex:(NSInteger)idx或<key>AtIndexes格式的方法
 若countOf<key>和另外两个中的一个被找到，那么就会返回一个可以响应NSArray所�有方法的代理集合(它是NSKeyValueArray，是NSArray的子类)，调用这个代理集合的方法，或者说给这个代理集合发送属于NSArray的方法，就会以countOf<Key>,objectIn<Key>AtIndex�或<Key>AtIndexes这几个方法组合的形式调用。
 若还是没哟找到，同时会查找enumeratorOf<key>,memberOf<key>、countOfStrr三个方法
 */

- (NSUInteger *)countOfStrr {
    return 3;
}

//下面两个是数组
//- (id)objectInStrrAtIndex:(NSInteger)idx {
//    
//    return @"";
//}
//
//- (id)strrAtIndexes {
//    return @"";
//}

//下面两个是集合
- (id)enumeratorOfStrr {
    return @"";
}

- (id)memberOfStrr {
    return @"";
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

//打印顺序
//2018-10-30 20:09:23.818787+0800 KVC&KVO[31118:663565] willChangeValueForKey
//2018-10-30 20:09:23.818920+0800 KVC&KVO[31118:663565] didChangeValueForKey-begin
//2018-10-30 20:09:29.625913+0800 KVC&KVO[31118:663565] dic--{
//    kind = 1;
//    new = 10;
//    old = 5;
//}
//2018-10-30 20:09:29.626116+0800 KVC&KVO[31118:663565] didChangeValueForKey-end

- (void)setAge:(NSUInteger)age {
    [self willChangeValueForKey:@"age"];
    _age = age;
    [self didChangeValueForKey:@"age"];
}

- (void)willChangeValueForKey:(NSString *)key {
    [super willChangeValueForKey:key];
    NSLog(@"willChangeValueForKey");
}

- (void)didChangeValueForKey:(NSString *)key {
    NSLog(@"didChangeValueForKey-begin");
    [super didChangeValueForKey:key];
    NSLog(@"didChangeValueForKey-end");
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    return NO;
}
@end
