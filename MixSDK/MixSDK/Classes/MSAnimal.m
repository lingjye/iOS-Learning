//
//  MSAnimal.m
//  MixSDK
//
//  Created by txooo on 2018/7/18.
//

#import "MSAnimal.h"
#import <MixSDK/MixSDK-Swift.h>
//#import <TXMacro/TXMacroHeader.h>

@implementation MSAnimal

+ (void)show {
    NSLog(@"%@", [self class]);
    [MSPeople show];
}

@end
