//
//  ALLRootViewController.m
//  AutoLayoutLearning
//
//  Created by txooo on 2019/3/21.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ALLRootViewController.h"
#import "ALLStackViewController.h"
#import "ALLVFLViewController.h"
#import "ALLMasonryViewController.h"

@interface ALLRootViewController ()

@end

@implementation ALLRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ALLStackViewController *viewController = [[ALLStackViewController alloc] init];
        [self gotoNextViewController:viewController];
    } else {
        ALLVFLViewController *viewController = [[ALLVFLViewController alloc] init];
        [self gotoNextViewController:viewController];
    }
}

- (void)gotoNextViewController:(UIViewController *)nextViewController {
    [self.navigationController pushViewController:nextViewController animated:YES];
}

@end
