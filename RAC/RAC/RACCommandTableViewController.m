//
//  RACCommandTableViewController.m
//  RAC
//
//  Created by txooo on 2019/4/16.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "RACCommandTableViewController.h"

@interface RACCommandTableViewController ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation RACCommandTableViewController

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

- (void)racCommand1 {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // 一般用于网络请求
            NSLog(@"%s, %@", __func__, input);
            if ([input isEqualToString:@"123"]) {
                [subscriber sendNext:@"abc"];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:nil];
            }
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"订阅取消");
            }];
            // 当sendError时触发 retry:1 重新执行一次 不指定重试次数或者指定0将一直重试知道sendCompleted
        }] retry:1];
    }];
    // 订阅最新值
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];

    [command execute:@"123"];
    // 在发送完成前, 再次发送不会响应
    [command execute:@"456"];

    // RACCommand.executing 默认会触发一次 指定接收次数
    [[[command.executing skip:1] take:2] subscribeNext:^(id x) {
        if ([x boolValue]) {
            NSLog(@"正则执行");
        } else {
            NSLog(@"执行完毕");
            [command execute:@"789"];
        }
    }];
    // 订阅error信息
    [command.errors subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];

    // 必须先订阅 才能收到信号 (以下无法收不到)
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
}

- (void)racCommand2 {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            if ([input isEqual:@"1"]) {
                [subscriber sendNext:input];
                [subscriber sendCompleted];
            } else {
                NSError *error = [NSError
                    errorWithDomain:@"com.text.rac"
                               code:-1
                           userInfo:@{ NSLocalizedFailureReasonErrorKey : @"errorReason",
                                       NSLocalizedDescriptionKey : @"errorDescription" }];
                [subscriber sendError:error];
            }
            return nil;
        }];
    }];

    [[[[[command execute:@"1"]
        doNext:^(id x) {
            NSLog(@"%s, %@", __func__, x);
        }]
        doError:^(NSError *error) {
            NSLog(@"%s, %@", __func__, error);
        }]
        doCompleted:^{
            NSLog(@"%s, 完成", __func__);
            [command execute:@"2"];
        }]
        subscribeNext:^(id x) {
            NSLog(@"%s, %@", __func__, x);
        }];

    [command.errors subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [@[
            @"racCommand1",
            @"racCommand2"
        ] mutableCopy];
    }
    return _datas;
}

@end
