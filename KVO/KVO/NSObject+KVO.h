//
//  NSObject+KVO.h
//  KVO
//
//  Created by txooo on 2019/5/15.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVO)

- (void)lj_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end
