//
//  MFLAutoDictionary.h
//  MessageForwardLearning
//
//  Created by 领琾 on 2018/3/18.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFLAutoDictionary : NSObject

@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSDate   *date;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) id opaqueProperty;

@end
