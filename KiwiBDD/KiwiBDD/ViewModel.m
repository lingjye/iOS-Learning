//
//  ViewModel.m
//  KiwiBDD
//
//  Created by txooo on 2019/5/21.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewModel.h"

@implementation ViewModel

- (NSString *)name {
    return NSStringFromClass(self.class);
}

- (void)loadData:(resultBlock)resultBlock {
    // Request
    NSArray *array = @[ @"a", @"b", @"c", @"d", @"e" ];
    [self.datas addObjectsFromArray:array];

    resultBlock(array);
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

@end
