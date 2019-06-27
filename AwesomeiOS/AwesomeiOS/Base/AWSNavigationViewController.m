//
//  AWSNavigationViewController.m
//  AwesomeiOS
//
//  Created by txooo on 2018/9/12.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import "AWSNavigationViewController.h"

@interface AWSNavigationViewController ()

@end

@implementation AWSNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count>=1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
