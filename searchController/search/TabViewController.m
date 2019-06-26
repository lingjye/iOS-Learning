//
//  TabViewController.m
//  search
//
//  Created by txooo on 2018/12/4.
//  Copyright © 2018 txooo. All rights reserved.
//

#import "TabViewController.h"
#import "ViewController.h"
#import "BaseNavigationViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    ViewController *view1 = ViewController.alloc.init;
    ViewController *view2 = ViewController.alloc.init;

    BaseNavigationViewController *nav1 = [[BaseNavigationViewController alloc] initWithRootViewController:view1];
    BaseNavigationViewController *nav2 = [[BaseNavigationViewController alloc] initWithRootViewController:view2];

    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"view1" image:nil tag:0];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"view2" image:nil tag:1];

    nav1.tabBarItem = item1;
    nav2.tabBarItem = item2;

    view1.title = @"view1";
    view2.title = @"view2";
    
    [self addChildViewController:nav1];
    [self addChildViewController:nav2];
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
