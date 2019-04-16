//
//  RACSequenceTableViewController.m
//  RAC
//
//  Created by txooo on 2019/4/16.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "RACSequenceTableViewController.h"

@interface RACSequenceTableViewController ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation RACSequenceTableViewController

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

// 数组
- (void)sequence_array1 {
    NSArray *array = [[self.datas.rac_sequence.signal flattenMap:^RACStream *(id value) {
        // 此处需要用returnSignal
        return [RACReturnSignal return:[value stringByAppendingString:@"_hello"]];
    }] toArray];
    NSLog(@"%s, %@", __func__, array);
}

- (void)sequence_array2 {
    RACSequence *sequence = [self.datas.rac_sequence flattenMap:^RACStream *(id value) {
        return [RACSequence return:[value stringByAppendingString:@"_hello"]];
    }];
    [sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    NSLog(@"%s, %@", __func__, sequence.array);
}

- (void)sequence_array3 {
    NSArray *array = [[self.datas.rac_sequence map:^id(id value) {
        return [value stringByAppendingString:@"_hello"];
    }] array];
    NSLog(@"%s, %@", __func__, array);
}

// 字典
- (void)sequence_dictionary1 {
    NSDictionary *dict = @{
        @"key1" : @"value_1",
        @"key2" : @"value_2",
        @"key3" : @"value_3"
    };
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        RACTupleUnpack(NSString * key, NSString * value) = x;
        NSLog(@"%s, %@, %@:%@", __func__, x, key, value);
    }];
}

- (void)sequence_dictionary2 {
    NSDictionary *dict = @{
        @"key1" : @"value_1",
        @"key2" : @"value_2",
        @"key3" : @"value_3"
    };
    [dict.rac_keySequence.signal subscribeNext:^(id x) {
        NSLog(@"%s, key: %@", __func__, x);
    }];
}

- (void)sequence_dictionary3 {
    NSDictionary *dict = @{
        @"key1" : @"value_1",
        @"key2" : @"value_2",
        @"key3" : @"value_3"
    };
    [dict.rac_valueSequence.signal subscribeNext:^(id x) {
        NSLog(@"%s, value: %@", __func__, x);
    }];
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [@[
            @"sequence_array1",
            @"sequence_array2",
            @"sequence_array3",
            @"sequence_dictionary1",
            @"sequence_dictionary2",
            @"sequence_dictionary3"
        ] mutableCopy];
    }
    return _datas;
}

@end
