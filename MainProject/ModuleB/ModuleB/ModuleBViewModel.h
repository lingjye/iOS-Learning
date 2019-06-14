//
//  ModuleBViewModel.h
//  CTMediatorDemo
//
//  Created by txooo on 2019/6/11.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModuleBViewModel : NSObject

- (instancetype)initWithParams:(NSDictionary *)params;

@property (nonatomic, strong) NSDictionary *params;

@end

NS_ASSUME_NONNULL_END
