//
//  PersonA.m
//  LibaryPCH
//
//  Created by txooo on 2019/6/13.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "PersonA.h"
#import "AnimalA.h"

@interface PersonA ()
{
    AnimalA *_animal;
}
@end

@implementation PersonA

- (instancetype)init {
    if (self = [super init]) {
        _animal = [[AnimalA alloc] init];
    }
    return self;
}

- (void)eat {
    [LibraryHelperA logging];
    NSLog(@"eat");
}

- (void)play {
    [LibraryHelperA logging];
    NSLog(@"play");
}

- (void)playAnimal {
    [LibraryHelperA logging];
    [_animal play];
}

- (void)request {
    [NetRequest request:^(id result) {
        NSLog(@"A %@ ", result);
    }];
}

- (void)sleep {
    NSLog(@"A sleep");
}

@end
