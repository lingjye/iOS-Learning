//
//  MSTView.m
//  MixSDKTwo
//
//  Created by huangyibo on 2021/4/28.
//

#import "MSTView.h"
// 使用 user_frameworks!
//#import <MixSDK/MixSDK-Swift.h>
//#import <MixSwift/MixSwift-Swift.h>
// 不使用 user_frameworks!
@import MixSDK;
@import MixSwift;

@implementation MSTView

- (void)mst_test {
    // 引用 MixSDK 的 Swift
    [MSModel show];
    // 引用 MixSwift 的 Swift
    [MixSwiftView log:@"123"];
}

@end
