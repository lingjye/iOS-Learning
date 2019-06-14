//
//  MKMediator+ModuleA.m
//  MKMediatorDemo
//
//  Created by txooo on 2019/6/11.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MKMediator+ModuleA.h"

@implementation MKMediator (ModuleA)

- (UIViewController *)moduleAViewControllerWithCallback:(void (^)(NSString * _Nonnull))callback {
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    params[@"callback"] = callback;
//    return [self performTarget:@"ModuleA" action:@"viewController" params:params shouldCacheTarget:NO];
    NSURL *url = [NSURL URLWithString:@"http://ModuleA/viewController?module=ModuleA"];
    return [self performActionWithUrl:url completion:^(NSDictionary *info) {
        NSLog(@"%@", info);
        callback(info[@"result"]);
    }];
}

- (void)configMiddlewares {
    self.middleware(@"MKViewController logging").middlewareAction(MKMediatorAction.sClsMethod(@"MKViewController middleware").params(MKMediatorParameters.create.key(@"middleware").value(@"excu middleware").dictionary));
}
@end
