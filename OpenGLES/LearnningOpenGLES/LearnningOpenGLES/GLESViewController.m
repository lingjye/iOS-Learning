//
//  GLESViewController.m
//  LearnningOpenGLES
//
//  Created by 领琾 on 2019/6/27.
//  Copyright © 2019 领琾. All rights reserved.
//

#import "GLESViewController.h"
#import "GLView.h"
#import "TRIGLView.h"

@interface GLESViewController ()

@end

@implementation GLESViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect frame = [UIScreen mainScreen].bounds;
    if (self.index == 1) {
         GLView *view = [GLView.alloc initWithFrame:frame];
        [self.view addSubview:view];
    } else if (self.index == 2) {
        TRIGLView *view = [[TRIGLView alloc] initWithFrame:frame];
        [self.view addSubview:view];
    }
    
}

@end
