//
//  RACSubjectTableViewController.m
//  RAC
//
//  Created by txooo on 2019/4/16.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "RACSubjectTableViewController.h"

@interface RACSubjectTableViewController ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation RACSubjectTableViewController

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

- (void)subject {
    RACSubject *subject = [RACSubject subject];
    // 必须先订阅, 才能发送
    [subject sendNext:@"abc"];
    // 指明生命周期
    [[subject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];

    [subject sendNext:@"123"];
}

- (void)replaySubject {
    RACReplaySubject *subject = [RACReplaySubject subject];
    // 可以先发送, 后订阅
    [subject sendNext:@"abc"];
    [subject subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
    [subject sendNext:@"123"];
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [@[
            @"subject",
            @"replaySubject"
        ] mutableCopy];
    }
    return _datas;
}

@end
