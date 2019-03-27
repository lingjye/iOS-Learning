//
//  MFLDog.m
//  MessageForwardLearning
//
//  Created by txooo on 2019/3/26.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MFLDog.h"

@interface MFLSmallDog : NSObject

@end

@implementation MFLSmallDog

- (void)eat {
    NSLog(@"%@ --- %s", [self class], __func__);
}

- (void)run {
    NSLog(@"%@ --- %s", [self class], __func__);
}

@end

@implementation MFLDog

// 第二步 快速消息转发 调用未实现的实例方法 在该方法中返回新的实例, 会转发到新的对象上调用
// 特点:简单、快速、但仅能转发给一个对象。
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [[MFLSmallDog alloc] init];
}

// forwardingTargetForSelector返回nil 调用该方法
- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"%s -- %@", __func__, NSStringFromSelector(aSelector));
}

@end
