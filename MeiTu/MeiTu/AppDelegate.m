//
//  AppDelegate.m
//  MeiTu
//
//  Created by txooo on 2019/4/3.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeViewController.h"

@interface AppDelegate ()
@property (nonatomic, assign) UIBackgroundTaskIdentifier taskIdentifier;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    
    WelcomeViewController *viewController = [[WelcomeViewController alloc] init];
    self.window.rootViewController = viewController;
    
    [self.window makeKeyAndVisible];
    CFRunLoopObserverCallBack callback = NULL;
    // 检查卡顿
    CFRunLoopObserverContext context = {0, (__bridge void*)self, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, callback, &context);
    __block NSInteger timeoutCount = 0, dispatchSemaphore = 0, runLoopActivity = 0;
    
    // 创建子线程监控
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 子线程开启一个持续的loop用来进行监控
        while (1) {
            long semaphoreWait = dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC));
            if (semaphoreWait != 0) {
                if (!observer) {
                    timeoutCount = 0;
                    dispatchSemaphore = 0;
                    runLoopActivity = 0;
                    return ;
                }
                // BeforeSources 和 AfterWaiting 这两个状态能够检测到是否卡顿
                if (runLoopActivity == kCFRunLoopBeforeSources || runLoopActivity == kCFRunLoopAfterWaiting) {
                    // 将堆栈信息上报服务器的代码放到这里
                }
                //end activity
            } // end semaphore wait
            timeoutCount = 0;
        }// end while
    });
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    self.taskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
        // 最多执行三分钟
        NSLog(@"后台任务");
        NSLog(@"end=============");
        NSLog(@"callStackSymbols : %@",[NSThread callStackSymbols]);
        
        [[UIApplication sharedApplication] endBackgroundTask:self.taskIdentifier];
        self.taskIdentifier = UIBackgroundTaskInvalid;
    }];
    NSLog(@"后台任务:%tu", self.taskIdentifier);
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
