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

// 备用接受者 如果要执行完整消息转发机制处理消息，此处应返回nil
- (id)forwardingTargetForSelector:(SEL)aSelector {
//    MFLAnimal *animal = [[MFLAnimal alloc] init];
//    if ([animal respondsToSelector:aSelector]) {
//        return animal;
//    }
    return nil;
}

// 完整消息转发 如果只是把消息转给备用接收者 建议采用转发机制第二步（forwardingTargetForSelector：）返回备用接受者处理
// 否则需要创建完整的签名过程，而返回备用接受者则更为简单
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
