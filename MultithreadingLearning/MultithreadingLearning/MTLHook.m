//
//  MTLHook.m
//  MultithreadingLearning
//
//  Created by txooo on 2019/4/1.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MTLHook.h"
#import <objc/runtime.h>

@implementation MTLHook

+ (void)hookClass:(Class)classObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector {
    // 得到被替换类的实例方法
    Method fromMethod = class_getInstanceMethod(classObject, fromSelector);
    // 得到替换类的实例方法
    Method toMethod = class_getInstanceMethod(classObject, toSelector);
    
    // class_addMethod 返回成功表示被替换的方法没实现, 然后会通过class_addMethod方法先实现；返回失败则表示被替换方法已存在，可以直接进行 IMP指针交换
    if (class_addMethod(classObject, fromSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        // 进行方法的替换
        class_replaceMethod(classObject, fromSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod));
    }else {
        // 交换IMP指针
        method_exchangeImplementations(fromMethod, toMethod);
    }
}

@end
