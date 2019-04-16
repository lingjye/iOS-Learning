//
//  MVVMNetworkTableViewController.m
//  RAC
//
//  Created by txooo on 2019/4/16.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MVVMNetworkTableViewController.h"
#import "MVVMViewModel.h"

@interface MVVMNetworkTableViewController ()

@property (nonatomic, strong) MVVMViewModel *viewModel;

@end

@implementation MVVMNetworkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self loadData];
}

- (void)loadData {

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    // Configure the cell...
    cell.textLabel.text = self.viewModel.datas[indexPath.row];
    return cell;
}

- (MVVMViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MVVMViewModel alloc] init];
    }
    return _viewModel;
}

@end
