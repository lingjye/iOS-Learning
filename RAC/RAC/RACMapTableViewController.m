//
//  RACMapTableViewController.m
//  RAC
//
//  Created by txooo on 2019/4/16.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "RACMapTableViewController.h"

@interface RACMapTableViewController ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation RACMapTableViewController

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

- (void)map {
    // 映射 改变值
    RACSubject *subject = [RACSubject subject];
    RACSignal *signal = [subject map:^id(id value) {
        return [value stringByAppendingString:@"_hello"];
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
    [subject sendNext:@"hi"];
}

- (void)flattenMap1 {
    RACSubject *subject = [RACSubject subject];
    [[subject flattenMap:^RACStream *(id value) {
        return [RACReturnSignal return:[value stringByAppendingString:@"_hello"]];
    }] subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];

    [subject sendNext:@"123"];
}

- (void)flattenMap2 {
    // 用于信号中的信号
    RACSubject *signal = [RACSubject subject];
    RACSubject *signalOfSignal = [RACSubject subject];

    [[signalOfSignal flattenMap:^RACStream *(id value) {
        return value;
    }] subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
    [signalOfSignal sendNext:signal];
    [signal sendNext:@"123"];
}

- (void)flattenMap3 {
    [[self.datas.rac_sequence.signal flattenMap:^RACStream *(id value) {
        // block: 源信号发送内容调用
        // value: 源信号发送的内容
        // 返回值: 包装修改内容的值
        return [RACReturnSignal return:[value stringByAppendingString:@"_hello"]];
    }] subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [@[
            @"map",
            @"flattenMap1",
            @"flattenMap2",
            @"flattenMap3"
        ] mutableCopy];
    }
    return _datas;
}

@end
