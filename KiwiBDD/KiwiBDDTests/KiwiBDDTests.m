//
//  KiwiBDDTests.m
//  KiwiBDDTests
//
//  Created by txooo on 2019/5/21.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "ViewModel.h"

SPEC_BEGIN(KiwiBDDTests)

// describe 表示要测试的对象
describe(@"ViewModel", ^{
    // context 表示不同场景下的行为, 一个describe中可以有多个context
    context(@"Test", ^{
        // context所有it开始之前
        beforeAll(^{
            NSLog(@"before all");
        });
        // 同一个context下每一个it调用之前都会调用beforeEach
        beforeEach(^{
            id viewModel = [[ViewModel alloc] init];
            [[[viewModel name] should] equal:@"ViewModel"];
        });
        // it 表示测试内容, 一个context中可以有多个it
        it(@"load data", ^{
            // 测试内容, DSL语法, 链式调用
            // should 表示一个期待, 用来验证对象行为是否满足期望
            id viewModel = [[ViewModel alloc] init];
            [viewModel loadData:^(NSArray *result) {
                [[result shouldNot] beEmpty];
            }];
        });
        
        it(@"Math", ^{
            NSUInteger a = 16;
            NSUInteger b = 26;
            [[theValue(a + b) should] equal:theValue(43)];
        });
    });
});

SPEC_END
