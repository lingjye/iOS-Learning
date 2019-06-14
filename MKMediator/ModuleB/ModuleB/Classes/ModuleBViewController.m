//
//  ModuleBViewController.m
//  MKMediatorDemo
//
//  Created by txooo on 2019/6/10.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ModuleBViewController.h"
#import "ModuleBViewModel.h"

@interface ModuleBViewController ()
@property (nonatomic, strong) ModuleBViewModel *viewModel;
@end

@implementation ModuleBViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        _viewModel = [[ModuleBViewModel alloc] initWithParams:params];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.redColor;
    self.navigationItem.title = self.viewModel.params[@"title"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
