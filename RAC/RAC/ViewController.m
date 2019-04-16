//
//  ViewController.m
//  RAC
//
//  Created by txooo on 2019/4/15.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewController.h"
#import "RACSkipTableViewController.h"
#import "RACMapTableViewController.h"
#import "RACCombineTableViewController.h"
#import "RACBindTableViewController.h"
#import "RACSignalTableViewController.h"
#import "RACSubjectTableViewController.h"
#import "RACSequenceTableViewController.h"
#import "RACCommandTableViewController.h"
#import "RACMacroTableViewController.h"
#import "RACMulticastConnectionViewController.h"
#import "MVVMTableViewController.h"

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
    NSString *title = self.datas[indexPath.row];
    UIViewController *viewController = nil;
    if (indexPath.row == 0) {
        viewController = [self filter];
    } else if (indexPath.row == 1) {
        viewController = [self map];
    } else if (indexPath.row == 2) {
        viewController = [self combine];
    } else if (indexPath.row == 3) {
        viewController = [self bind];
    } else if (indexPath.row == 4) {
        viewController = [self macro];
    } else if (indexPath.row == 5) {
        viewController = [self racSignal];
    } else if (indexPath.row == 6) {
        viewController = [self racSubject];
    } else if (indexPath.row == 7) {
        viewController = [self racSequence];
    } else if (indexPath.row == 8) {
        viewController = [self racCommand];
    } else if (indexPath.row == 9) {
        viewController = [self multicastConnection];
    } else if (indexPath.row == 10) {
        viewController = [self mvvm];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UIViewController *)filter {
    return [[RACSkipTableViewController alloc] init];
}

- (UIViewController *)map {
    return [[RACMapTableViewController alloc] init];
}

- (UIViewController *)combine {
    return [[RACCombineTableViewController alloc] init];
}

- (UIViewController *)bind {
    return [[RACBindTableViewController alloc] init];
}

- (UIViewController *)macro {
    return [[RACMacroTableViewController alloc] init];
}

- (UIViewController *)racSignal {
    return [[RACSignalTableViewController alloc] init];
}

- (UIViewController *)racSubject {
    return [[RACSubjectTableViewController alloc] init];
}

- (UIViewController *)racSequence {
    return [[RACSequenceTableViewController alloc] init];
}

- (UIViewController *)racCommand {
    return [[RACCommandTableViewController alloc] init];
}

- (UIViewController *)multicastConnection {
    return [[RACMulticastConnectionViewController alloc] init];
}

- (UIViewController *)mvvm {
    return [[MVVMTableViewController alloc] init];
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [@[
            @"过滤",
            @"映射",
            @"组合",
            @"bind",
            @"常用宏",
            @"RACSignal",
            @"RACSubject",
            @"RACSequence",
            @"RACComand",
            @"RACMuticastConnection",
            @"MVVM",
        ] mutableCopy];
    }
    return _datas;
}

@end
