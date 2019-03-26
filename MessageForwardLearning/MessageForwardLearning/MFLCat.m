//
//  MFLCat.m
//  MessageForwardLearning
//
//  Created by txooo on 2019/3/26.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MFLCat.h"

@interface MFLSmallCat : NSObject

@end

@implementation MFLSmallCat

- (void)eat {
    NSLog(@"%@ --- %s", [self class], __func__);
}

@end

@implementation MFLCat

// 第三步 生成新的方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"%s --- %@", __func__, NSStringFromSelector(aSelector));
    // 转发当前对象的eat方法到MFLSmallCat实例中去调用
    if ([NSStringFromSelector(aSelector) isEqualToString:@"eat"]) {
        SEL selector = aSelector;
        id target = MFLSmallCat.new;
        // 创建新的方法签名
        NSMethodSignature *signature = [target methodSignatureForSelector:selector];
        // 创建NSInvocation对象, 包装签名对象
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        // 设置invocation的target为新的target
        invocation.target = target;
        invocation.selector = selector;
        // 开始调用
        [invocation invoke];
        return signature;
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%s -- %@", __func__, anInvocation);
}

- (void)run {
    NSLog(@"%@ --- %s", [self class], __func__);
}

@end
