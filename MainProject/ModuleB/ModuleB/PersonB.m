//
//  PersonB.m
//  LibaryPCH
//
//  Created by txooo on 2019/6/13.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "PersonB.h"
#import "AnimalB.h"

@interface PersonB ()
{
    AnimalB *_animal;
}
@end

@implementation PersonB

- (instancetype)init {
    if (self = [super init]) {
        _animal = [[AnimalB alloc] init];
    }
    return self;
}

- (void)eat {
    [LibraryHelperB logging];
    NSLog(@"eat");
}

- (void)play {
    [LibraryHelperB logging];
    NSLog(@"play");
}

- (void)playAnimal {
    [LibraryHelperB logging];
    [_animal play];
}

- (void)request {
//    [NetRequest request:^(id result) {
//        NSLog(@"B %@ ", result);
//    }];
}

- (void)run {
    NSLog(@"B run");
}

- (void)sleep {
    NSLog(@"B sleep");
}

@end
