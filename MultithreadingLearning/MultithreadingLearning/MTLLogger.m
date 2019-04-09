//
//  MTLLogger.m
//  MultithreadingLearning
//
//  Created by txooo on 2019/4/1.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MTLLogger.h"

@implementation MTLLogger

static MTLLogger *mtlloger = nil;

+ (instancetype)logger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mtlloger = [[MTLLogger alloc] init];
    });
    return mtlloger;
}

- (void)log:(NSString *)log {
    // 此处对日志进行处理
    NSLog(@"%@", log);
}

@end
