//
//  JSObject.m
//  JSBrigde
//
//  Created by txooo on 2019/4/4.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "JSObject.h"

@implementation JSObject

- (NSString *)sayFullName {
    return [self fullName];
}

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@%@", _firstName, _lastName];
}

@end
