//
//  RACCombineTableViewController.m
//  RAC
//
//  Created by txooo on 2019/4/16.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "RACCombineTableViewController.h"

@interface RACCombineTableViewController ()

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation RACCombineTableViewController

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
    self.selectIndex = indexPath.row;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(self.datas[indexPath.row])];
#pragma clang diagnostic pop
}

- (void)combineLatest {
    RACSignal *combineSignal = [RACSignal
        combineLatest:@[ RACObserve(self, title),
                         RACObserve(self, selectIndex) ]
               reduce:^id(NSString *title, NSNumber *number) {
                   // reduce 参数一定要和combinLatest数组参数顺序一致, 任意源信号变化都会调用
                   return @(title.length && number.integerValue > 0);
               }];
    [combineSignal subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
    // 此信号可用来对button的enabled状态绑定
}

- (void)merge {
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    [[subject1 merge:subject2] subscribeNext:^(id x) {
        // 任意信号发送都会调用
        NSLog(@"%s, %@", __func__, x);
    }];
    // 接收到的数据根据发送信号的先后变化
    [subject1 sendNext:@"123"];
    [subject2 sendNext:@"abc"];
}

- (void)zipWith {
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    [[subject1 zipWith:subject2] subscribeNext:^(id x) {
        // 将所有信号压缩成一个信号发送, 所有值将会被包装成元组发送
        NSLog(@"%s, %@", __func__, x);
    }];
    // 元组内数据顺序根据压缩顺序变化
    [subject1 sendNext:@1];
    [subject1 sendNext:@2];
    [subject2 sendNext:@"a"];
    [subject2 sendNext:@"b"];
    // 必须成对发送 单独一个发送, 无法接收
    [subject2 sendNext:@"c"];
}

- (void)then {
    // then 先执行上一个信号 后执行下一个信号 并且会忽略到第一个信号的所有值
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@2];
        [subscriber sendCompleted];
        return nil;
    }];

    RACSignal *thenSignal = [signal1 then:^RACSignal * {
        return signal2;
    }];

    [thenSignal subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
}

- (void)contact {
    // 执行顺序同then 但都可获取值
    RACSignal *singal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 请求1
        [subscriber sendNext:@1];
        // 必须调用 或者调用sendError
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 请求2
        [subscriber sendNext:@2];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *contactSignal = [singal1 concat:signal2];
    [contactSignal subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [@[
            @"combineLatest",
            @"merge",
            @"zipWith",
            @"then",
            @"contact"
        ] mutableCopy];
    }
    return _datas;
}

@end
