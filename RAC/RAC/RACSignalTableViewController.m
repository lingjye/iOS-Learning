//
//  RACSignalTableViewController.m
//  RAC
//
//  Created by txooo on 2019/4/16.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "RACSignalTableViewController.h"

@interface RACSignalTableViewController ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation RACSignalTableViewController

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
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    // Configure the cell...
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(self.datas[indexPath.row])];
#pragma clang diagnostic pop
}

- (void)signal {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"abc"];
        // 必须调用 或者调用sendError
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            // 信号取消订阅时调用
            NSLog(@"%s, 订阅取消", __func__);
        }];
    }];
    // 订阅后返回取消订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
    // 取消订阅
    [disposable dispose];
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [@[
            @"signal"
        ] mutableCopy];
    }
    return _datas;
}

@end
