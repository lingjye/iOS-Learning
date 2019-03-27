//
//  MFLParrot+Animal.h
//  MessageForwardLearning
//
//  Created by txooo on 2019/3/27.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MFLParrot.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFLParrot (Animal)

- (void)sing;

@property (nonatomic, assign) NSInteger wingNumber;

@end

NS_ASSUME_NONNULL_END
