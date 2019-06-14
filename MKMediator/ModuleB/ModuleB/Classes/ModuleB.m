//
//  ModuleB.m
//  MKMediatorDemo
//
//  Created by txooo on 2019/6/11.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ModuleB.h"
#import "ModuleBViewController.h"

@implementation ModuleB

- (UIViewController *)viewController:(NSDictionary *)params {
    ModuleBViewController *viewController = [[ModuleBViewController alloc] initWithParams:params];
    return viewController;
}

- (UIViewController *)notFound:(NSDictionary *)params {
    NSLog(@"未找到:%@", params);
    return nil;
}
@end
