//
//  NetRequest.h
//  PublicModule
//
//  Created by txooo on 2019/6/13.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^NetRequestResult)(id result);

@interface NetRequest : NSObject

+ (void)request:(NetRequestResult)result;

@end

NS_ASSUME_NONNULL_END
