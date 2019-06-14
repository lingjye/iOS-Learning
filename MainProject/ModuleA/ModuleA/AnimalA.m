//
//  AnimalA.m
//  LibaryPCH
//
//  Created by txooo on 2019/6/13.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "AnimalA.h"

@implementation AnimalA

- (void)play {
    [LibraryHelperA logging];
    NSLog(@"%@--play", [self class]);
}

@end
