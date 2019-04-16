//
//  RACMacroTableViewController.m
//  RAC
//
//  Created by txooo on 2019/4/16.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "RACMacroTableViewController.h"

@interface RACMacroTableViewController ()

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) NSString *testTitle;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation RACMacroTableViewController

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

- (void)RACObserve {
    [RACObserve(self, testTitle) subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
}

- (void)RAC_RACObserve {
    // 用于给某个对象的某个属性绑定。
    RAC(self, testTitle) = [RACObserve(self, title) map:^id(id value) {
        return [value stringByAppendingString:@"_hello"];
    }];
}

- (void)weakify_strongify {
    // 解决循环引用
    @weakify(self);
    [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        NSIndexPath *indexaPath = tuple.last;
        self.selectIndex = indexaPath.row;
    }];

    [RACObserve(self, selectIndex) subscribeNext:^(id x) {
        NSLog(@"%s, %@", __func__, x);
    }];
}

- (void)RACTuplePack {
    // 包装元组
    RACTuple *tuple = RACTuplePack(@1, @2, @3);
    NSLog(@"%s, %@", __func__, tuple);
}

- (void)RACTupleUnPack {
    // 解包
    RACTuple *tuple = RACTuplePack(@1, @2);
    RACTupleUnpack(NSNumber * number1, NSNumber * number2) = tuple;
    NSLog(@"%s, %@, %@", __func__, number1, number2);
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [@[
            @"RACObserve",
            @"RAC_RACObserve",
            @"weakify_strongify",
            @"RACTuplePack",
            @"RACTupleUnPack"
        ] mutableCopy];
    }
    return _datas;
}

@end
