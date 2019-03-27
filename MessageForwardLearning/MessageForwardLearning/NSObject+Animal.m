//
//  MFLBird+Animal.m
//  MessageForwardLearning
//
//  Created by txooo on 2019/3/27.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "NSObject+Animal.h"

@implementation NSObject (Animal)

- (void)sleep {
    NSLog(@"%@ -- %s", [self class], __func__);
}

@end
