//
//  MFLAnimal.m
//  MessageForwardLearning
//
//  Created by txooo on 2019/3/26.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MFLAnimal.h"

@implementation MFLAnimal

- (void)eat {
    NSLog(@"%@ --- %s", [self class], __func__);
}

//- (void)sleep {
//    NSLog(@"%@ --- %s", [self class], __func__);
//}

- (void)run {
    NSLog(@"%@ --- %s", [self class], __func__);
}

@end
