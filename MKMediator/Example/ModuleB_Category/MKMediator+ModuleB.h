//
//  MKMediator+ModuleB.h
//  MKMediatorDemo
//
//  Created by txooo on 2019/6/11.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MKMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKMediator (ModuleB)

- (UIViewController *)moduleBViewControllerWithParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
