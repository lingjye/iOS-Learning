//
//  MFLParrot.m
//  MessageForwardLearning
//
//  Created by txooo on 2019/3/27.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MFLParrot.h"
#import "MFLAnimal.h"
#import "MFLBird.h"

@implementation MFLParrot

// 快速转发
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    MFLAnimal *animal = [[MFLAnimal alloc] init];
//    if ([animal respondsToSelector:aSelector]) {
//        return animal;
//    }
//    return nil;
//}

// 标准转发
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"%s --- %@", __func__, NSStringFromSelector(aSelector));
    // 转发当前对象的eat方法到MFLSmallCat实例中去调用
    id target = [[MFLAnimal alloc] init];
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

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"%s -- %@", __func__, NSStringFromSelector(aSelector));
}

@end
