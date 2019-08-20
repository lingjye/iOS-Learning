//
//  NSObject+KVO.m
//  KVO
//
//  Created by txooo on 2019/5/15.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

const char *KVOObserverKey = "KVOObserverKey";
const char *KVOObserverKeyPathKey = "KVOObserverKeyPathKey";
const char *KVOObserverContextKey = "KVOObservercontextKey";
const char *KVOObserverOldValueKey = "KVOObserverOldValueKey";

@implementation NSObject (KVO)

- (void)lj_addObserver:(NSObject *)observer
            forKeyPath:(NSString *)keyPath
               options:(NSKeyValueObservingOptions)options
               context:(void *)context {
    // 创建观察类 参考Viewcontroller顶部注释
    const char *kvoClassName =
        [[@"KVO_" stringByAppendingString:NSStringFromClass(self.class)] UTF8String];
    // 创建类, 参数: 父类 当前类 0
    Class kvoClass = objc_allocateClassPair([self class], kvoClassName, 0);
    // 添加setter方法, 即重写原类setter方法Thread 3
    NSString *capitalizedFirstChar = [keyPath
        stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                withString:[[keyPath substringToIndex:1] capitalizedString]];
    NSString *setterName = [@"set" stringByAppendingString:capitalizedFirstChar];
    
    // v@:@
    // v 代表void， i表示int 作为返回值
    // @:@ 代表传入一个参数
    // type encodings 参考：https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
    class_addMethod(kvoClass, NSSelectorFromString([setterName stringByAppendingString:@":"]),
                    (IMP)setter, "v@:@");
    
    // 可根据options 进行其他操作, 此处默认new | old
    
    // 注册新添加的这个类
    objc_registerClassPair(kvoClass);

    // 修改isa指针, 指向观察类
    object_setClass(self, kvoClass);

    // 设置属性关联, 绑定观察者
    objc_setAssociatedObject(self, &KVOObserverKey, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &KVOObserverKeyPathKey, keyPath,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &KVOObserverContextKey, (__bridge id _Nullable)(context),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &KVOObserverOldValueKey, [self valueForKeyPath:keyPath],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 重写父类setter
void setter(id self, SEL _cmd, NSString *value) {
    // 保存当前类
    Class class = [self class];

    // 将self的isa指针重新指向父类
    object_setClass(self, class_getSuperclass(class));

    // 调用父类
    objc_msgSend(self, _cmd, value);

    // 拿出观察者
    NSObject *object = objc_getAssociatedObject(self, &KVOObserverKey);
    NSString *keyPath = objc_getAssociatedObject(self, &KVOObserverKeyPathKey);
    id oldValue = objc_getAssociatedObject(self, &KVOObserverOldValueKey);
    id context = objc_getAssociatedObject(self, &KVOObserverContextKey);
    
    NSMutableDictionary *change = [@{} mutableCopy];
    if (oldValue) {
        change[@"old"] = oldValue;
    }
    if (value) {
        change[@"new"] = value;
    }

    // 调用父类方法, 并传递参数
    objc_msgSend(object, @selector(observeValueForKeyPath:ofObject:change:context:), keyPath, object, change, context, nil);
    
    // 改为子类
    object_setClass(self, class);
}

@end
