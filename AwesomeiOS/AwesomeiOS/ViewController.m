//
//  ViewController.m
//  AwesomeiOS
//
//  Created by txooo on 2018/9/12.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *pushViewControllers;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UI";
    [self.dataArray addObjectsFromArray:@[ @"心电图", @"仿Siri脉冲", @"K线图", @"画板" ]];
}

- (void)configTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = self.dataArray[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *viewController = [NSClassFromString(self.pushViewControllers[indexPath.row]) new];
    viewController.title = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)pushViewControllers {
    if (!_pushViewControllers) {
        _pushViewControllers = [NSMutableArray arrayWithObjects:@"AWSHeartRateViewController",
                                @"AWSSiriWaveViewController",
                                @"AWSKlineViewController",
                                @"AWSPaintViewController",
                                nil];
    }
    return _pushViewControllers;
}

@end
