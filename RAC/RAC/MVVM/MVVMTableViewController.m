//
//  MVVMTableViewController.m
//  RAC
//
//  Created by txooo on 2019/4/16.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MVVMTableViewController.h"
#import "MVVMViewModel.h"

@interface MVVMTableViewController ()

@property (nonatomic, strong) MVVMViewModel *viewModel;

@end

@implementation MVVMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self bindViewModels];
    [self loadData];
}

- (void)bindViewModels {
    @weakify(self);
    [self.viewModel.errors subscribeNext:^(NSError *error) {
        NSLog(@"错误:%@", error.localizedDescription);
    }];
    
    [self.viewModel.loadDataCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"成功:%@", x);
        [self.tableView reloadData];
    }];
    
    [[self.viewModel.loadDataCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue]) {
            NSLog(@"请求中...");
        } else {
            NSLog(@"请求结束");
        }
    }];
}

- (void)loadData {
    [self.viewModel.loadDataCommand execute:@1];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel.loadDataCommand execute:@(indexPath.row % 2)];
}

- (MVVMViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MVVMViewModel alloc] init];
    }
    return _viewModel;
}

@end
