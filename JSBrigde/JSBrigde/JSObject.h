//
//  JSObject.h
//  JSBrigde
//
//  Created by txooo on 2019/4/4.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSObject : NSObject<JSProtocol>

- (NSString *)sayFullName;

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

@end

NS_ASSUME_NONNULL_END
