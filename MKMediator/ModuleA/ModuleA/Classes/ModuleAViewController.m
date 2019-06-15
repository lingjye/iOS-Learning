//
//  ModuleAViewController.m
//  MKMediatorDemo
//
//  Created by txooo on 2019/6/10.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ModuleAViewController.h"
#import <MKMediator/MKMediator.h>

@interface ModuleAViewController ()
@property (nonatomic, strong) MKMediator *mediator;
@end

@implementation ModuleAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"ModuleA";
    self.view.backgroundColor = UIColor.greenColor;

    UIButton *button = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"Click goto ModuleB" forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [btn setBackgroundColor:UIColor.redColor];
        [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        btn;
    });
    [self.view addSubview:button];
    [self.view addConstraints:@[
        [NSLayoutConstraint constraintWithItem:button
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1
                                      constant:0],
        [NSLayoutConstraint constraintWithItem:button
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:100],
        [NSLayoutConstraint constraintWithItem:button
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1
                                      constant:250],
        [NSLayoutConstraint constraintWithItem:button
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1
                                      constant:50]
    ]];
}

- (void)click {
    UIViewController *viewController = self.mediator.dispatch(
        MKMediatorAction.sClsMethod(@"ModuleB viewController")
            .params(MKMediatorParameters.create.key(@"title").value(@"ModlueA->ModuleB").dictionary));
    [self.navigationController pushViewController:viewController animated:YES];
}

- (MKMediator *)mediator {
    if (!_mediator) {
        _mediator = [[MKMediator alloc] init];
    }
    return _mediator;
}

@end
