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
//#import <PublicModule/PublicModule.h>
//#import <AFNetworking.h>

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
    
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_offset(50);
//        make.right.mas_offset(-50);
//        make.height.mas_equalTo(50);
//        make.top.mas_offset(100);
//    }];
}

- (void)requestData {
//    [NetRequest request:^(id result) {
//        NSLog(@"Main %@", result);
//    }];
//    [NetRequest loging];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:@"http://www.baidu.com" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@", error.localizedDescription);
//    }];
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
