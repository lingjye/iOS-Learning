//
//  Target_ModuleA.m
//  CTMediatorDemo
//
//  Created by txooo on 2019/6/11.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "Target_ModuleA.h"
#import "ModuleAViewController.h"

@implementation Target_ModuleA

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"创建");
    }
    return self;
}

- (UIViewController *)Action_viewController:(NSDictionary *)params {
    typedef void (^CallbackBlock)(NSString *);
    CallbackBlock callback = params[@"callback"];
    if (callback) {
        callback(@"success");
    }
    ModuleAViewController *viewController = [[ModuleAViewController alloc] init];
    return viewController;
}

- (UIViewController *)notFound:(NSDictionary *)params {
    NSLog(@"未找到:%@", params);
    return nil;
}

@end
