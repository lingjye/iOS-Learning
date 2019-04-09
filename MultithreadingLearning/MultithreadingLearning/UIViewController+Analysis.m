//
//  UIViewController+UIViewController_Analysis.m
//  MultithreadingLearning
//
//  Created by txooo on 2019/4/1.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "UIViewController+Analysis.h"
#import "MTLHook.h"
#import "MTLLogger.h"

@implementation UIViewController (Analysis)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 通过@selector获得被替换和替换方法的SEL, 作为hook的对象
        
        SEL fromSelector1 = @selector(viewWillAppear:);
        SEL fromSelector2 = @selector(viewWillDisappear:);
        
        SEL toSelector1 = @selector(hook_viewWillAppear:);
        SEL toSelector2 = @selector(hook_viewWllDisappear:);
        
        [MTLHook hookClass:self fromSelector:fromSelector1 toSelector:toSelector1];
        [MTLHook hookClass:self fromSelector:fromSelector2 toSelector:toSelector2];
    });
}

- (void)hook_viewWillAppear:(BOOL)animation {
    // 先执行插入如代码, 在执行原方法
    [self insertMethodBeforeViewWillAppear];
    [self hook_viewWillAppear:animation];
}

- (void)insertMethodBeforeViewWillAppear {
    // 日志埋点
    [[MTLLogger logger] log:[NSString stringWithFormat:@"%@-%s", NSStringFromClass([self class]), __func__]];
}

- (void)hook_viewWllDisappear:(BOOL)animation {
    [self hook_viewWllDisappear:animation];
}

- (void)insertMethodAfterViewWillAppear {
    [[MTLLogger logger] log:[NSString stringWithFormat:@"%@-%s", NSStringFromClass([self class]), __func__]];
}

@end
