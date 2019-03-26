//
//  MFLPig.m
//  MessageForwardLearning
//
//  Created by txooo on 2019/3/26.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MFLPig.h"
#import <objc/runtime.h>

@implementation MFLPig

// 调用未实现的实例方法，会调用这个方法,并把对应的方法列表传过来
// 动态解析 实例方法 存在于当前对象对应的类的方法列表中
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"%s --- %@", __func__, NSStringFromSelector(sel));
    
    Method method = class_getInstanceMethod(self, @selector(eat));
    class_addMethod(self, @selector(sleep), method_getImplementation(method), "v@:");
    
    return YES;
}

// 动态解析 类方法 存在于类的元类的方法列表中
// 调用未实现的类方法，会调用这个方法,并把对应的方法列表传过来
+ (BOOL)resolveClassMethod:(SEL)sel {
    NSLog(@"%s --- %@", __func__, NSStringFromSelector(sel));
    
    Method method = class_getClassMethod(self, @selector(eat));
    class_addMethod(object_getClass(self), @selector(sleep), method_getImplementation(method), "v@:");
    
    return YES;
}

- (void)eat {
    NSLog(@"%@ --- %s", [self class], __func__);
}

+ (void)eat {
    NSLog(@"%@ --- %s", [self class], __func__);
}

@end
