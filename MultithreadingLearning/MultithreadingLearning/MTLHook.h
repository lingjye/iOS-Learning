//
//  MTLHook.h
//  MultithreadingLearning
//
//  Created by txooo on 2019/4/1.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLHook : NSObject

+ (void)hookClass:(Class)classObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector;

@end

NS_ASSUME_NONNULL_END
