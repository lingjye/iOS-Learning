

    //
//  RACBindTableViewController.m
//  RAC
//
//  Created by txooo on 2019/4/16.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "RACBindTableViewController.h"

@interface RACBindTableViewController ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation RACBindTableViewController

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

- (void)bind {
    RACSubject *subject = [RACSubject subject];
    RACSignal *bindSignal = [subject bind:^RACStreamBindBlock{
        // block 绑定信号就会调用 此处一般不做处理
        return ^RACSignal *(id value, BOOL *stop) {
            // 处理一般在此处开始
            // (源信号)绑定信号发送新值时调用
            NSLog(@"接收到的内容:%@", value);
            // *stop = YES 本次订阅后终止
            if ([value isEqualToString:@"123"]) {
                *stop = YES;
            }
            // 返回信号 或者empty
            return [RACReturnSignal return:[value stringByAppendingString:@"_hello"]];
        };
    }];
    
    [bindSignal subscribeNext:^(id x) {
        // 改变后的值
        NSLog(@"%s, %@", __func__, x);
    }];
    [subject sendNext:@"abc"];
    [subject sendNext:@"123"];
    [subject sendNext:@"456"];
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [@[
            @"bind"
        ] mutableCopy];
    }
    return _datas;
}

@end
