//
//  Person.m
//  KVO
//
//  Created by txooo on 2019/5/15.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (void)initialize {
    NSLog(@"Person---%s", __func__);
}

+ (void)load {
    NSLog(@"Person---%s", __func__);
}

//- (void)setName:(NSString *)name {
//    [self willChangeValueForKey:@"name"];
//    _name = name;
//    [self didChangeValueForKey:@"name"];
//}

// 设置对该 key 不自动发送通知（返回 NO 即可
//+ (BOOL)automaticallyNotifiesObserversOfName {
//    return NO;
//}

@end




@implementation Man

+ (void)initialize {
    NSLog(@"Man---%s", __func__);
}

+ (void)load {
    NSLog(@"Man---%s", __func__);
}

@end

@interface Person (cat)

@end

@implementation Person (cat)

+ (void)initialize {
    NSLog(@"Person_catogory--%s--cat", __func__);
}

+ (void)load {
    NSLog(@"Person_catogory---%s----cat", __func__);
}


@end
