//
//  RACMulticastConnectionViewController.m
//  RAC
//
//  Created by txooo on 2019/4/16.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "RACMulticastConnectionViewController.h"

@interface RACMulticastConnectionViewController ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation RACMulticastConnectionViewController

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
        // 有几个订阅者就会发送几次
        NSLog(@"发送消息");
        [subscriber sendNext:@"123"];
        [subscriber sendCompleted];
        return nil;
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅者1: %@", x);
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅者2: %@", x);
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅者3: %@", x);
    }];
}

- (void)multicastConnection {
    // 冷信号转换为热信号 适用场景:多个订阅者订阅一个信号, 不需要发送多个消息
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 不管有几个订阅者, 只发送一次
        NSLog(@"发送消息");
        [subscriber sendNext:@"abc"];
        [subscriber sendCompleted];
        return nil;
    }];
    // 创建连接类
    RACMulticastConnection *connection = [signal publish];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅者1: %@", x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅者2: %@", x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅者3: %@", x);
    }];
    // 创建连接, 此过程将会把冷信号转化为热信号
    [connection connect];
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [@[
            @"signal",
            @"multicastConnection",
        ] mutableCopy];
    }
    return _datas;
}

@end
