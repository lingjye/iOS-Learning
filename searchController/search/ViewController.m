//
//  ViewController.m
//  search
//
//  Created by txooo on 2018/12/4.
//  Copyright © 2018 txooo. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"
#import "NormalTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *nextButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"前往搜索" forState:UIControlStateNormal];
        [button setBackgroundColor:UIColor.redColor];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(CGRectGetWidth(self.view.bounds)/2.0 - 50, 100, 100, 100);
        button;
    });
    [self.view addSubview:nextButton];
    
}

- (void)buttonClick:(UIButton *)button {
    if ([self.navigationItem.title isEqualToString:@"view2"]) {
        NormalTableViewController *viewController = [[NormalTableViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
    SearchViewController *viewController = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
