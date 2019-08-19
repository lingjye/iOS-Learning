//
//  ViewController.m
//  RunLoopDemo
//
//  Created by txooo on 2019/8/19.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSTimer *timer = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSRunLoopCommonModes];

    NSRunLoop *mainLoop = [NSRunLoop mainRunLoop];
    
    // CoreFoundation
    CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();
    CFRunLoopRef mainLoopRef = CFRunLoopGetMain();
    
    [self runLoopObserver];
    
//    NSArray *allModes = CFBridgingRelease(CFRunLoopCopyAllModes(runLoopRef));
//    while (1) {
//        for (NSString *mode in allModes) {
//            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
//        }
//    }
}

static void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"RunLoop进入");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"RunLoop将要处理Timer");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"RunLoop将要处理Sources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"RunLoop将要休眠");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"RunLoop唤醒");
            break;
        case kCFRunLoopExit:
            NSLog(@"RunLoop退出");
            break;
        default:
            break;
    }
}

- (void)runLoopObserver {
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities,YES,0,&callBack,&context);
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
#if 0
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"RunLoop进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"RunLoop将要处理Timer");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"RunLoop将要处理Sources");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"RunLoop将要休眠");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"RunLoop唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"RunLoop退出");
                break;
            default:
                break;
        }
    });
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    CFRelease(observer);
#endif
}

- (void)timerRun {
    NSLog(@"timer");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 断点，控制台输入命令bt，查看 __CFRunLoopDoSources0
    NSLog(@"%@", event);
    NSLog(@"%@---", [touches allObjects][10]);
}


@end
