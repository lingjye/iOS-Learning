//
//  NetRequest.h
//  PublicModule
//
//  Created by txooo on 2019/6/13.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^NetRequestResult)(id result);

@interface NetRequest : NSObject

+ (void)request:(NetRequestResult)result;

+ (void)logging:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
