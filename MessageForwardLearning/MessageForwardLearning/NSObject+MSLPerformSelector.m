//
//  NSObject+MSLPerformSelector.m
//  MessageForwardLearning
//
//  Created by txooo on 2019/3/26.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "NSObject+MSLPerformSelector.h"
#import <UIKit/UIKit.h>

@implementation NSObject (MSLPerformSelector)

- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects {
    // 方法签名(方法的描述)
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    if (signature == nil) {
        [NSException raise:NSLocalizedString(@"错误", nil) format:NSLocalizedString(@"%@方法找不到", nil), NSStringFromSelector(selector)];
    }
    
    // NSInvocation : 利用一个NSInvocation对象包装一次方法调用（方法调用者、方法名、方法参数、方法返回值）
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    
    // 设置参数
    NSInteger paramsCount = signature.numberOfArguments - 2; // 除self、_cmd以外的参数个数, 系统方法会添加
    // 避免参数不全
    paramsCount = MIN(paramsCount, objects.count);
    for (NSInteger i = 0; i < paramsCount; i++) {
        id object = objects[i];
        if ([object isKindOfClass:[NSNull class]]) continue;
        [invocation setArgument:&object atIndex:i + 2];
    }
    
    // 调用方法
    [invocation invoke];
    
    // 获取返回值,有返回值类型，才去获得返回值, 列举了几种常见类型, 基本可以满足需求
    if (signature.methodReturnLength) {
        NSLog(@"---%s", signature.methodReturnType);
        NSString *returnTypeString = [NSString stringWithUTF8String:signature.methodReturnType];
        if ([returnTypeString isEqualToString:@"@"]) {
            id __unsafe_unretained returnValue;
            [invocation getReturnValue:&returnValue];
            return returnValue;
        } else if ([returnTypeString isEqualToString:@"B"]) {
            bool returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSNumber numberWithBool:returnValue];
        } else if ([returnTypeString isEqualToString:@"f"]) {
            float returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSNumber numberWithFloat:returnValue];
        } else if ([returnTypeString isEqualToString:@"d"]) {
            bool returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSNumber numberWithDouble:returnValue];
        } else if ([returnTypeString isEqualToString:@"c"]) {
            bool returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSNumber numberWithChar:returnValue];
        } else if ([returnTypeString isEqualToString:@"i"]) {
            bool returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSNumber numberWithInt:returnValue];
        } else if ([returnTypeString isEqualToString:@"I"]) {
            bool returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSNumber numberWithUnsignedInt:returnValue];
        } else if ([returnTypeString isEqualToString:@"s"]) {
            bool returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSNumber numberWithShort:returnValue];
        } else if ([returnTypeString isEqualToString:@"l"]) {
            bool returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSNumber numberWithLong:returnValue];
        } else if ([returnTypeString isEqualToString:@"q"]) {
            bool returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSNumber numberWithLongLong:returnValue];
        } else if ([returnTypeString isEqualToString:@"C"]) {
            bool returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSNumber numberWithUnsignedChar:returnValue];
        } else if ([returnTypeString isEqualToString:@"S"]) {
            bool returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSNumber numberWithUnsignedShort:returnValue];
        } else if ([returnTypeString isEqualToString:@"L"]) {
            bool returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSNumber numberWithUnsignedLong:returnValue];
        } else if ([returnTypeString isEqualToString:@"Q"]) {
            bool returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSNumber numberWithUnsignedLongLong:returnValue];
        } else if ([returnTypeString isEqualToString:@"#"]) {
            //return Class
            Class returnValue;
            [invocation getReturnValue:&returnValue];
            return returnValue;
        } else if ([returnTypeString isEqualToString:@"{CGRect={CGPoint=dd}{CGSize=dd}}"]) {
            CGRect returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSValue valueWithCGRect:returnValue];
        } else if ([returnTypeString isEqualToString:@"{CGSize=dd}"]) {
            CGSize returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSValue valueWithCGSize:returnValue];
        } else if ([returnTypeString isEqualToString:@"{CGPoint=dd}"]) {
            CGPoint returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSValue valueWithCGPoint:returnValue];
        } else if ([returnTypeString isEqualToString:@"{_NSRange=QQ}"]) {
            NSRange returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSValue valueWithRange:returnValue];
        } else if ([returnTypeString isEqualToString:@"{UIEdgeInsets=dddd}"]) {
            UIEdgeInsets returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSValue valueWithUIEdgeInsets:returnValue];
        } else if ([returnTypeString isEqualToString:@"{NSDirectionalEdgeInsets=dddd}"]) {
            NSDirectionalEdgeInsets returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSValue valueWithDirectionalEdgeInsets:returnValue];
        } else if ([returnTypeString isEqualToString:@"{UIOffset=dd}"]) {
            UIOffset returnValue;
            [invocation getReturnValue:&returnValue];
            return [NSValue valueWithUIOffset:returnValue];
        } else if ([returnTypeString isEqualToString:@":"]) {
            SEL returnValue;
            [invocation getReturnValue:&returnValue];
            return NSStringFromSelector(returnValue);
        } else if ([returnTypeString isEqualToString:@"?"]) {
            //? unknown type
            @try {
                id returnValue;
                [invocation getReturnValue:&returnValue];
                return returnValue;
            } @catch (NSException *exception) {
                NSLog(@"%@", exception.description);
            } @finally {
                return nil;
            }
        }
    }
    return nil;
}

@end
