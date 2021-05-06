//
//  MSAnimal.m
//  MixSDK
//
//  Created by txooo on 2018/7/18.
//

#import "MSAnimal.h"
//#import "MixSDK/MixSDK-Swift.h"
//#import <MixSwift/MixSwift-Swift.h>
#import "MixSDK-Swift.h"
@import MixSwift;


@implementation MSAnimal

+ (void)show {
    NSLog(@"%@", [self class]);
    [MSPeople show];
    [MixSwiftView log:@"123"];
}

- (void)eat {
    NSLog(@"%@---%s", [self class], __func__);
}

@end
