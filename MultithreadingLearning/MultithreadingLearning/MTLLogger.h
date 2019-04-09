//
//  MTLLogger.h
//  MultithreadingLearning
//
//  Created by txooo on 2019/4/1.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLLogger : NSObject

+ (instancetype)logger;

/**
 log content

 @param log exmple: [NSString stringWithFormat:@"%@%@", class, method]
 */
- (void)log:(NSString *)log;

@end

NS_ASSUME_NONNULL_END
