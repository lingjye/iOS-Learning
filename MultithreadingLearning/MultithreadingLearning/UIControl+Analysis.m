//
//  UIButton+Analysis.m
//  MultithreadingLearning
//
//  Created by txooo on 2019/4/1.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "UIControl+Analysis.h"
#import "MTLLogger.h"
#import "MTLHook.h"

@implementation UIControl (Analysis)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 通过@selector 获得被替换和替换的方法
        SEL fromSelector = @selector(sendAction:to:forEvent:);
        SEL toSelector = @selector(hook_sendAction:to:forEvent:);

        [MTLHook hookClass:self fromSelector:fromSelector toSelector:toSelector];
    });
}

- (void)hook_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [self insertToSendAction:action to:target forEvent:event];
    [self hook_sendAction:action to:target forEvent:event];
}

- (void)insertToSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    // 日志记录
    if (event.allTouches.anyObject.phase == UITouchPhaseEnded) {
        NSString *className = NSStringFromClass([target class]);
        [[MTLLogger logger] log:[NSString stringWithFormat:@"%@-%@", className, NSStringFromSelector(action)]];
    }
}

@end
