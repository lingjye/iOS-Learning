//
//  SearchResultViewController.m
//  search
//
//  Created by txooo on 2018/12/4.
//  Copyright © 2018 txooo. All rights reserved.
//

#import "SearchResultViewController.h"
#import "NormalTableViewController.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

static NSString *const cellID = @"cellID";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(ios 11.0,*)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 60;
    self.tableView.sectionHeaderHeight = 0.0f;
    self.tableView.sectionFooterHeight = 0.0f;
}

-(void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (self.dataArray.count > indexPath.row) {
        id data = self.dataArray[indexPath.row];
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = self.dataArray[indexPath.row];
            cell.textLabel.text = dict[@"name"];
        }else{
            cell.textLabel.text = self.dataArray[indexPath.row];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NormalTableViewController *controller = [[NormalTableViewController alloc] init];
    [self.presentingViewController.navigationController pushViewController:controller animated:YES];
}

@end
