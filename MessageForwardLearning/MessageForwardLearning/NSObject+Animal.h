//
//  MFLBird+Animal.h
//  MessageForwardLearning
//
//  Created by txooo on 2019/3/27.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Animal)

// 让所有子类都有sleep方法
- (void)sleep;

@end

NS_ASSUME_NONNULL_END
