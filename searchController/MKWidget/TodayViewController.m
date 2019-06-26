//
//  TodayViewController.m
//  MKWidget
//
//  Created by txooo on 2018/12/5.
//  Copyright © 2018 txooo. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "NormalTableViewController.h"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    //Today Extension的页面加一个可点击打开containingAPP的label
    UILabel *openAppLabel = [[UILabel alloc] init];
    openAppLabel.textColor = [UIColor colorWithRed:(97.0/255.0) green:(97.0/255.0) blue:(97.0/255.0) alpha:1];
    openAppLabel.backgroundColor = [UIColor clearColor];
    openAppLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
    openAppLabel.textAlignment = NSTextAlignmentCenter;
    openAppLabel.text = @"点击打开app";
    openAppLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:openAppLabel];
    openAppLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *openURLContainingAPP = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openURLContainingAPP)];
    [openAppLabel addGestureRecognizer:openURLContainingAPP];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 100, 20)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
}

- (void)openURLContainingAPP {
    //scheme为app的scheme
    [self.extensionContext openURL:[NSURL URLWithString:@"search://add"]
                 completionHandler:^(BOOL success) {
                     NSLog(@"open url result:%d",success);
                 }];
//    NormalTableViewController *bs = [[NormalTableViewController alloc] init];
//    [self presentViewController:bs animated:YES completion:^{
//
//    }];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
        // 设置展开的新高度
        self.preferredContentSize = CGSizeMake(0, 180);
    }else{
        self.preferredContentSize = maxSize;
    }
}

@end
