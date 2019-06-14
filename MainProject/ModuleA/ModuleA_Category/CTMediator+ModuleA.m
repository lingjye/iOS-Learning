//
//  CTMediator+ModuleA.m
//  CTMediatorDemo
//
//  Created by txooo on 2019/6/11.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "CTMediator+ModuleA.h"

@implementation CTMediator (ModuleA)

- (UIViewController *)moduleAViewControllerWithCallback:(void (^)(NSString * _Nonnull))callback {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"callbck"] = callback;
    return [self performTarget:@"ModuleA" action:@"viewController" params:params shouldCacheTarget:NO];
}

@end
