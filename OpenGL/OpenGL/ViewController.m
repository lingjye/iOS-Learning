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
    
}

- (IBAction)push:(id)sender {
    GLTViewController *viewController = [[GLTViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
