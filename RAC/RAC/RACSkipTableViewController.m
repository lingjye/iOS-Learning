//
//  RACSkipTableViewController.m
//  RAC
//
//  Created by txooo on 2019/4/15.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "RACSkipTableViewController.h"

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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(self.datas[indexPath.row])];
#pragma clang diagnostic pop
}

- (void)skip {
    // 跳跃过前面n个值
    RACSubject *subject = [RACSubject subject];
    [[subject skip:1] subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
}

- (void)distinctUntilChanged {
    // 一直到变化时触发
    RACSubject *subject = [RACSubject subject];
    [[subject distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@2];
}

- (void)take {
    RACSubject *subject = [RACSubject subject];
    [[subject take:2] subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
}

- (void)takeLast {
    // 取最后n个值
    RACSubject *subject = [RACSubject subject];
    [[subject takeLast:2] subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
    // 一定要调用完成
    [subject sendCompleted];
}

- (void)takeUntil {
    // 当传递的信号发送sendNext或者sendCompleted, 就不在接受新内容
    RACSubject *subject = [RACSubject subject];
    RACSubject *subject1 = [RACSubject subject];
    [[subject takeUntil:subject1] subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
    [subject sendNext:@1];
    //    [subject1 sendNext:@2];
    [subject1 sendCompleted];
    [subject sendNext:@3];
}

- (void)ignore {
    // 忽略某些值
    RACSubject *subject = [RACSubject subject];
    RACSignal *ignoreSignal = [subject ignore:@2];
    [ignoreSignal subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
}

- (void)filter {
    // 过滤一些值
    [[self.datas.rac_sequence.signal filter:^BOOL(id value) {
        return [value length] > 4;
    }] subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [@[
            @"skip",
            @"distinctUntilChanged",
            @"take",
            @"takeLast",
            @"takeUntil",
            @"ignore",
            @"filter"
        ] mutableCopy];
    }
    return _datas;
}

@end
