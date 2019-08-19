//
//  main.m
//  RunLoopDemo
//
//  Created by txooo on 2019/8/19.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

static int s_fatal_signals[] = {
    SIGABRT,
    SIGBUS,
    SIGFPE,
    SIGILL,
    SIGSEGV,
    SIGTRAP,
    SIGTERM,
    SIGKILL
};

static int s_fatal_signal_num = sizeof(s_fatal_signals) / sizeof(s_fatal_signals[0]);

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *exceptionArray = [exception callStackSymbols];
    NSString *exceptionReason = exception.reason;
    NSString *exceptionName = exception.name;
    NSLog(@"Error:%@---%@---%@", exceptionArray, exceptionReason, exceptionName);
    [[NSRunLoop mainRunLoop] run];
}

void SignalHander(int code) {
    NSLog(@"Code:%d", code);
}

void InitCrashReport () {
    // 系统错误信息捕获
    for (int i = 0; i < s_fatal_signal_num; i++) {
        signal(s_fatal_signals[i], SignalHander);
    }
    
    // 捕获异常
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
        InitCrashReport();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
