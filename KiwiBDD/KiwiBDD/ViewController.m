//
//  ViewController.m
//  KiwiBDD
//
//  Created by txooo on 2019/5/21.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewController.h"
#import "ViewModel.h"

@interface ViewController ()

@property (nonatomic, strong) ViewModel *viewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _viewModel = [[ViewModel alloc] init];
    [_viewModel loadData:^(id  _Nonnull result) {
        NSLog(@"%@", result);
    }];
}

@end
