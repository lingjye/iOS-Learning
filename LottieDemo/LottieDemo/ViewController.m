//
//  ViewController.m
//  LottieDemo
//
//  Created by txooo on 2019/5/7.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewController.h"
#import <Lottie/Lottie.h>
#import "LottieDemo-Swift.h"
#import <PromiseKit/PromiseKit.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LOTAnimationView *animationView = [LOTAnimationView animationNamed:@"data.json"];
    animationView.frame = self.view.frame;
    animationView.loopAnimation = YES;
    animationView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:animationView];
    
    [animationView play];
    
    UIButton *nextButton = ({
        UIButton *button = [UIButton buttonWithType:0];
        [button setTitle:@"下一页" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 50, CGRectGetMaxY(self.view.frame) - 100, 100, 50);
        button;
    });
    [self.view addSubview:nextButton];
}

- (void)nextPage {
    LottieDemoViewController *viewController = [[LottieDemoViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}

@end
