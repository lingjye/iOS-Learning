//
//  MKMediator+ModuleB.m
//  MKMediatorDemo
//
//  Created by txooo on 2019/6/11.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MKMediator+ModuleB.h"

@implementation MKMediator (ModuleB)

- (UIViewController *)moduleBViewControllerWithParams:(NSDictionary *)params {
    return [self performTarget:@"ModuleB" action:@"viewController" params:params shouldCacheTarget:NO];
}

@end
