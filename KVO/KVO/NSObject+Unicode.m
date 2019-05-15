//
//  NSObject+Description.m
//  KVO
//
//  Created by txooo on 2019/5/15.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "NSObject+Unicode.h"
#import <objc/runtime.h>

static inline void lj_swizzleInstanceSelector(Class class, SEL originalSelector,
                                              SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation NSObject (Unicode)

@end

@implementation NSDictionary (Unicode)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        lj_swizzleInstanceSelector(class, @selector(description), @selector(lj_description));
        // 字典
        lj_swizzleInstanceSelector(class, @selector(descriptionWithLocale:),
                                   @selector(lj_descriptionWithLocale:));
        lj_swizzleInstanceSelector(class, @selector(descriptionWithLocale:indent:),
                                   @selector(lj_descriptionWithLocale:indent:));
    });
}

- (NSString *)lj_description {
    return [self stringByReplaceUnicode:[self lj_description]];
}

- (NSString *)lj_descriptionWithLocale:(nullable id)locale {
    return [self stringByReplaceUnicode:[self lj_descriptionWithLocale:locale]];
}

- (NSString *)lj_descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    return [self stringByReplaceUnicode:[self lj_descriptionWithLocale:locale indent:level]];
}

- (NSString *)stringByReplaceUnicode:(NSString *)unicodeString {
    NSMutableString *convertedString = [unicodeString mutableCopy];
    [convertedString replaceOccurrencesOfString:@"\\U"
                                     withString:@"\\u"
                                        options:0
                                          range:NSMakeRange(0, convertedString.length)];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);

    return convertedString;
}

@end
