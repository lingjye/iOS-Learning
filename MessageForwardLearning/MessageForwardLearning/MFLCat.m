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

// 第三步 标准消息转发 生成新的方法签名
// 特点: 复杂, 相对较慢, 转发灵活可控, 可转发给多个对象
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"%s --- %@", __func__, NSStringFromSelector(aSelector));
    // 转发当前对象的eat方法到MFLSmallCat实例中去调用
    id target = [[MFLSmallCat alloc] init];
    if ([target respondsToSelector:aSelector]) {
        // 创建新的方法签名
        NSMethodSignature *signature = [target methodSignatureForSelector:aSelector];
        // 创建NSInvocation对象, 包装签名对象
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        // 设置invocation的target为新的target
        invocation.target = target;
        invocation.selector = aSelector;
        // 开始调用
        [invocation invoke];
        return signature;
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%s -- %@", __func__, anInvocation);
}

// methodSignatureForSelector返回nil 调用该方法
- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"%s -- %@", __func__, NSStringFromSelector(aSelector));
}

- (void)run {
    NSLog(@"%@ --- %s", [self class], __func__);
}

@end
