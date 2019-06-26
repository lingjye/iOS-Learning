//
//  ViewController.m
//  OpenGL
//
//  Created by txooo on 2019/2/25.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewController.h"
#import "GLTViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    [self.view addSubview:view];
    UIView *superView = [self findSuperView:view];
    NSLog(@"%@", superView);
    NSLog(@"%@", view);
    view.backgroundColor = UIColor.redColor;
    superView.backgroundColor = UIColor.yellowColor;
}

- (UIView *)findSuperView:(UIView *)view {
    for (; view.superview; view = view.superview);
    return view;
}

- (IBAction)push:(id)sender {
    GLTViewController *viewController = [[GLTViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
