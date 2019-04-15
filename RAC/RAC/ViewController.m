//
//  ViewController.m
//  RAC
//
//  Created by txooo on 2019/4/15.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *RACTestNotification = @"RACTestNotification";

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.tableView.tableFooterView = [[UIView alloc] init];
    self.title = @"RAC";

    [self testRAC];
}

- (void)testRAC {
    // 代理
    @weakify(self);
    [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:)
                    fromProtocol:@protocol(UITableViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        NSIndexPath *indexPath = tuple.last;
        @strongify(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:RACTestNotification object:indexPath];
        self.selectIndex = indexPath.row;
    }];
    
    // target-action
    UIButton *testButton = ({
        UIButton *button = [UIButton buttonWithType:0];
        button.frame = CGRectMake(100, 50, 100, 30);
        [button setTitle:@"点击" forState:UIControlStateNormal];
        [button setBackgroundColor:UIColor.redColor];
        button;
    });
    [self.view addSubview:testButton];
    
    [[testButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"点击:%@", x);
    }];
    
    // 通知 不需要移除
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:RACTestNotification object:nil] subscribeNext:^(NSNotification *noti) {
        NSLog(@"%@", noti.object);
    }];
    
    // KVO 不需要移除
    // 警告fix: pod 'ReactiveCocoa', :git => 'https://github.com/zhao0/ReactiveCocoa.git', :tag => '2.5.2'
    [RACObserve(self, selectIndex) subscribeNext:^(id x) {
        NSLog(@"%tu", [x integerValue]);
    }];
    
    [[[RACSignal
       combineLatest:@[ RACObserve(self, selectIndex), RACObserve(self, title) ]
       reduce:^(NSNumber *selectIndex, NSString *title) {
           return @(selectIndex.integerValue > 0 && title.length);
       }] distinctUntilChanged]
     subscribeNext:^(NSNumber *valid) {
         if (valid.boolValue) {
             NSLog(@"符合条件");
         } else {
             NSLog(@"不符合条件");
         }
     }];
    
    // 信号源 RACStream
    RACSubject *subject = [RACSubject subject];
    
    [self.datas.rac_sequence.signal subscribe:subject];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅:%@", x);
    }];
    
    // RACSequence
    NSArray *strings = @[ @"as", @"safaf", @"sfasdfds", @"dfdsg" ];
    NSArray *results = [[[strings.rac_sequence filter:^BOOL(NSString *str) {
        return str.length > 2;
    }] map:^id(NSString *str) {
        return [str stringByAppendingString:@"_hello"];
    }] array];
    NSLog(@"%@", results);
    
    RACDisposable *dispose = [RACDisposable disposableWithBlock:^{
        NSLog(@"Dispose");
    }];
    [dispose dispose];
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            return dispose;
        }];
    }];
    [command execute:nil];
}


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
    
    if (indexPath.row == 0) {
        [self skip];
    } else if (<#expression#>)
    
}

- (void)skip {
    
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [@[
            @[@"过滤", @"skip"],
            @[@"映射", @"map"],
            @[@"组合", @"combine"],
            @"bind",
            @"常用宏",
            @"RACSignal",
            @"RACSubject",
            @"RACComand",
            @"MVVM",
            @"MVVM+网络请求",
        ] mutableCopy];
    }
    return _datas;
}

@end
