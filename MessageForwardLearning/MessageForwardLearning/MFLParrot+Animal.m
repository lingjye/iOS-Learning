//
//  MFLParrot+Animal.m
//  MessageForwardLearning
//
//  Created by txooo on 2019/3/27.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MFLParrot+Animal.h"
#import <objc/runtime.h>

static const void *MFLParrotWingNumberKey = &MFLParrotWingNumberKey;

@implementation MFLParrot (Animal)

- (void)sing {
    NSLog(@"%@ -- %s", [self class], __func__);
}

- (void)setWingNumber:(NSInteger)wingNumber {
    objc_setAssociatedObject(self, MFLParrotWingNumberKey, @(wingNumber), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)wingNumber {
    NSNumber *number = objc_getAssociatedObject(self, MFLParrotWingNumberKey);
    return number.integerValue;
}

@end
