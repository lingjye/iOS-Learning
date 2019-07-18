//
//  MKViewController.m
//  MixSDK
//
//  Created by lingjye on 07/18/2018.
//  Copyright (c) 2018 lingjye. All rights reserved.
//

#import "MKViewController.h"
#import "MSAnimal.h"
#import "MixSDK_Example-Swift.h"
//@import MixSDK;

@interface MKViewController ()

@end

@implementation MKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [MSAnimal show];
    [MSPeople show];
    [MSModel show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
