//
//  ViewController.m
//  MainProject
//
//  Created by txooo on 2019/6/13.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewController.h"
#import <ModuleA/ModuleA.h>
#import <ModuleB/ModuleB.h>
#import <PublicModule/PublicModule.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self requestData];
    
    [self playA];
    [self playB];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"button" forState:UIControlStateNormal];
    [button setBackgroundColor:UIColor.redColor];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(50);
        make.right.mas_offset(-50);
        make.height.mas_equalTo(50);
        make.top.mas_offset(100);
    }];
}

- (void)requestData {
    [NetRequest request:^(NSString *result) {
        NSLog(@"Main %@", result);
    }];
}

- (void)playA {
    PersonA *person = [[PersonA alloc] init];
    [person playAnimal];
    [person request];
}

- (void)playB {
    PersonB *person = [[PersonB alloc] init];
    [person playAnimal];
    [person request];
}

@end
