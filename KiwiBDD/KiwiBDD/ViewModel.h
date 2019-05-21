//
//  ViewModel.h
//  KiwiBDD
//
//  Created by txooo on 2019/5/21.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^resultBlock)(id result);

@interface ViewModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSMutableArray *datas;

- (void)loadData:(resultBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
