//
//  AnimalB.m
//  LibaryPCH
//
//  Created by txooo on 2019/6/13.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "AnimalB.h"

@implementation AnimalB

- (void)play {
    [LibraryHelperB logging];
    NSLog(@"%@--play", [self class]);
}

@end
