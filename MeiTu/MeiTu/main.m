//
//  main.m
//  MeiTu
//
//  Created by txooo on 2019/4/3.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "fishhook.h"
#import <dlfcn.h>

static int s_fatal_signals[] = {
    SIGABRT,
    SIGBUS,
    SIGFPE,
    SIGILL,
    SIGSEGV,
    SIGTRAP,
    SIGTERM,
    SIGKILL,
};

static int s_fatal_signal_num = sizeof(s_fatal_signals) / sizeof(s_fatal_signals[0]);

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *exceptionArray = [exception callStackSymbols]; // 得到当前调用栈信息
    NSString *exceptionReason = [exception reason];       // 非常重要，就是崩溃的原因
    NSString *exceptionName = [exception name];           // 异常类型
}

void SignalHandler(int code)
{
    NSLog(@"signal handler = %d",code);
}

void InitCrashReport()
{
    // 系统错误信号捕获
    for (int i = 0; i < s_fatal_signal_num; ++i) {
        signal(s_fatal_signals[i], SignalHandler);
    }
    
    //oc 未捕获异常的捕获
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

// NSLog 重定向
static void (*orig_nslog)(NSString *format, ...);

void redirect_nslog(NSString *format, ...) {
    // 进行自己的处理
    printf("重定向\n");
    
    // 继续执行原NSLog
    va_list va;
    va_start(va, format);
    NSLogv(format, va);
    va_end(va);
}

// fishhook 测试
static int (*orig_close)(int);
static int (*orig_open)(const char *, int, ...);

int my_close(int fd) {
    printf("Calling real close(%d)\n", fd);
    return orig_close(fd);
}

int my_open(const char *path, int oflag, ...) {
    va_list ap = {0};
    mode_t mode = 0;
    
    if ((oflag & O_CREAT) != 0) {
        // mode only applies to O_CREAT
        va_start(ap, oflag);
        mode = va_arg(ap, int);
        va_end(ap);
        printf("Calling real open('%s', %d, %d)\n", path, oflag, mode);
        return orig_open(path, oflag, mode);
    } else {
        printf("Calling real open('%s', %d)\n", path, oflag);
        return orig_open(path, oflag, mode);
    }
}


int main(int argc, char * argv[]) {
    @autoreleasepool {
        InitCrashReport();
        struct rebinding nslog_rebinf = {"NSLog", redirect_nslog, (void *)&orig_nslog};
        rebind_symbols(&nslog_rebinf, 1);
        NSLog(@"try redirect nslog %@,%d", @"is that ok?", 1);
        
        rebind_symbols((struct rebinding[2]){{"close", my_close, (void *)&orig_close}, {"open", my_open, (void *)&orig_open}}, 2);
        
        // Open our own binary and print out first 4 bytes (which is the same
        // for all Mach-O binaries on a given architecture)
        int fd = open(argv[0], O_RDONLY);
        uint32_t magic_number = 0;
        read(fd, &magic_number, 4);
        printf("Mach-O Magic Number: %x \n", magic_number);
        close(fd);
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

