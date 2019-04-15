//
//  RACSkipTableViewController.m
//  RAC
//
//  Created by txooo on 2019/4/15.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "RACSkipTableViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACSkipTableViewController ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation RACSkipTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSelector:NSSelectorFromString(self.datas[indexPath.row])];
}

- (void)skip {
    RACSubject *subject = [RACSubject subject];
    [[subject skip:1] subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
}

- (void)distinctUntilChanged {
    RACSubject *subject = [RACSubject subject];
    [[subject distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@2];
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [@[ @"skip",
                     @"distinctUntilChanged",
                     @"take",
                     @"takeLast",
                     @"takeUtil",
                     @"ignore",
                     @"filter",
                     @"reduce" ] mutableCopy];
    }
    return _datas;
}

@end
