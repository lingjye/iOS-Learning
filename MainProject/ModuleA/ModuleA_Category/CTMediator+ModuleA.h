//
//  CTMediator+ModuleA.h
//  CTMediatorDemo
//
//  Created by txooo on 2019/6/11.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "CTMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (ModuleA)

- (UIViewController *)moduleAViewControllerWithCallback:(void (^)(NSString *result))callback;

@end

NS_ASSUME_NONNULL_END
