//
//  ViewController.m
//  MainProject
//
//  Created by txooo on 2019/6/14.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewController.h"
#import <ModuleA/ModuleA.h>
#import <ModuleB/ModuleB.h>
#import <ModuleB/ModuleBViewController.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *buttonA = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonA setTitle:@"ModuleA" forState:UIControlStateNormal];
    [buttonA setBackgroundColor:UIColor.redColor];
    [buttonA addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    buttonA.tag = 100;
    [self.view addSubview:buttonA];
    
    UIButton *buttonB = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonB setTitle:@"ModuleB" forState:UIControlStateNormal];
    [buttonB setBackgroundColor:UIColor.redColor];
    [buttonB addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    buttonB.tag = 101;
    [self.view addSubview:buttonB];
    
    [buttonA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(50);
        make.right.mas_offset(-50);
        make.height.mas_equalTo(50);
        make.top.mas_offset(100);
    }];
    
    [buttonB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(50);
        make.right.mas_offset(-50);
        make.height.mas_equalTo(50);
        make.top.equalTo(buttonA.mas_bottom).offset(10);
    }];
    
    [self requestData];
    [self playA];
    [self playB];
}

- (void)buttonClick:(UIButton *)button {
    if (button.tag == 100) {
        UIViewController *controller = [[CTMediator sharedInstance] moduleAViewControllerWithCallback:^(NSString * _Nonnull result) {
            NSLog(@"%@", result);
        }];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        UIViewController *controller = [[ModuleBViewController alloc] initWithParams:@{@"title":@"ModuleB"}];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)requestData {
    [NetRequest request:^(id result) {
        NSLog(@"Main %@", result);
    }];
    [NetRequest logging:@"request finish"];
}

- (void)playA {
    PersonA *person = [[PersonA alloc] init];
    [person playAnimal];
    [person request];
    [person sleep];
}

- (void)playB {
    PersonB *person = [[PersonB alloc] init];
    [person playAnimal];
    [person request];
    [person run];
    [person sleep];
}


@end
