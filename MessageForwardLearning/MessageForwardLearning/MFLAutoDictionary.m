//
//  MFLAutoDictionary.m
//  MessageForwardLearning
//
//  Created by 领琾 on 2018/3/18.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import "MFLAutoDictionary.h"
#import <objc/runtime.h>

@interface MFLAutoDictionary ()

@property (nonatomic, strong) NSMutableDictionary *backingStore;

@end

@implementation MFLAutoDictionary

@dynamic string, number, date, opaqueProperty;

- (instancetype)init {
    if (self) {
        _backingStore = [NSMutableDictionary new];
    }
    return self;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    if ([selectorString hasPrefix:@"set"]) {
        class_addMethod(self,
                        sel,
                        (IMP) autoDictionarySetter,
                        "v@:@");
    } else {
        class_addMethod(self,
                        sel,
                        (IMP) autoDictionaryGetter,
                        "@@:");
    }
    return YES;
}

void autoDictionarySetter(id self, SEL _cmd, id value) {
    MFLAutoDictionary *typeSelf = (MFLAutoDictionary *) self;
    NSMutableDictionary *backingStore = typeSelf.backingStore;

    NSString *selectorString = NSStringFromSelector(_cmd);
    NSMutableString *key = [selectorString mutableCopy];

    //remove the ':' at the end
    [key deleteCharactersInRange:NSMakeRange(key.length - 1, 1)];

    //remove the 'set' prefix
    [key deleteCharactersInRange:NSMakeRange(0, 3)];

    //lowercase the first character
    NSString *lowercaseString = [[key substringToIndex:1] lowercaseString];

    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:lowercaseString];

    if (value) {
        [backingStore setObject:value forKey:key];
    } else {
        [backingStore removeObjectForKey:key];
    }
}

id autoDictionaryGetter(id self, SEL _cmd) {
    MFLAutoDictionary *typeSelf = (MFLAutoDictionary *) self;
    NSMutableDictionary *backStore = typeSelf.backingStore;

    NSString *key = NSStringFromSelector(_cmd);
    return [backStore objectForKey:key];
}

@end
