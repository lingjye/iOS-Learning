//
//  AWSPaintViewController.m
//  AwesomeiOS
//
//  Created by txooo on 2018/9/18.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import "AWSPaintViewController.h"
#import "AWSPaintView.h"

@interface AWSPaintViewController ()

@end

@implementation AWSPaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AWSPaintView *paintView = [[AWSPaintView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:paintView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
