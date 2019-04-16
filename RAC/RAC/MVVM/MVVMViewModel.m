//
//  MVVMViewModel.m
//  RAC
//
//  Created by txooo on 2019/4/16.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MVVMViewModel.h"

@implementation MVVMViewModel

- (instancetype)init {
    if (self) {
        [self configViewModel];
    }
    return self;
}

- (void)configViewModel {
    [self.loadDataCommand.errors subscribe:self.errors];
}

- (RACCommand *)loadDataCommand {
    if (!_loadDataCommand) {
        _loadDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                // 模拟请求
                dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(delay, dispatch_get_main_queue(), ^{
                    if ([input isEqual:@1]) {
                        [subscriber sendNext:@"data"];
                        [subscriber sendCompleted];
                    } else {
                        NSError *error = [NSError
                            errorWithDomain:@"com.text.rac"
                                       code:-1
                                   userInfo:@{ NSLocalizedFailureReasonErrorKey : @"errorReason",
                                               NSLocalizedDescriptionKey : @"errorDescription" }];
                        [subscriber sendError:error];
                    }
                });
                return nil;
            }];
        }];
    }
    return _loadDataCommand;
}

- (RACSubject *)errors {
    if (!_errors) {
        _errors = [RACSubject subject];
    }
    return _errors;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [@[
            @"a",
            @"b",
            @"c",
            @"d",
            @"e",
            @"f",
            @"g"
        ] mutableCopy];
    }
    return _datas;
}

@end
