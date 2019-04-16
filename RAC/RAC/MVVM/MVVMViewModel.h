//
//  MVVMViewModel.h
//  RAC
//
//  Created by txooo on 2019/4/16.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVVMModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MVVMViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) RACCommand *loadDataCommand;

@property (nonatomic, strong) RACSubject *errors;

@end

NS_ASSUME_NONNULL_END
