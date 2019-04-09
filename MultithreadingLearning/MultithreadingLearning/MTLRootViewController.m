//
//  ViewController.m
//  MultithreadingLearning
//
//  Created by txooo on 2019/4/1.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MTLRootViewController.h"

#define XCodeAppIdentifier [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define kDispatchQueueIdentifier [XCodeAppIdentifier cStringUsingEncoding:NSUTF8StringEncoding]

@interface MTLRootViewController () {
    NSArray *_datas;
}
@end

@implementation MTLRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _datas = @[ @[ @"Serial Dispatch Queue",
                   @"Concurrent Dispatch Queue" ],
                    ];
}

- (IBAction)itemClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.tableView.editing = !self.tableView.editing;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_datas[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = _datas[indexPath.section][indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];

    if (section == 0) {
        titleLabel.text = @"种类";
    }
    [view addSubview:titleLabel];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                // 生成
                dispatch_queue_t serialDispatchQueue = dispatch_queue_create(kDispatchQueueIdentifier, NULL);
                // release
//                dispatch_release(serialDispatchQueue);
            } else {
                // 生成
                dispatch_object_t concurrentDispatchQueue = dispatch_queue_create(kDispatchQueueIdentifier, DISPATCH_QUEUE_CONCURRENT);
//                dispatch_release(concurrentDispatchQueue);
#if 0
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_group_t group = dispatch_group_create();
                dispatch_group_async(group, queue, ^{
                    NSLog(@"block 0");
                });
                
                dispatch_group_async(group, queue, ^{
                    NSLog(@"block 1");
                });
                
                dispatch_group_async(group, queue, ^{
                    NSLog(@"block 2");
                });
                
                dispatch_notify(group, dispatch_get_main_queue(), ^{
                    NSLog(@"打印");
                });
                
                // 等待执行结果
                //                dispatch_wait(group, dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC));
                
//#else
                // dispatch_apply
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_apply(10, queue, ^(size_t index) {
                    NSLog(@"%zu", index);
                });
                NSLog(@"完成");
#else
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
                // dispatch semaphore 的计数初始值设定为1
                // 保证可访问 NSMutableArray 类对象的线程同时只能有一个
                NSMutableArray *mutArray = [NSMutableArray array];
                
                for (int i = 0; i < 100; i++) {
                    dispatch_async(queue, ^{
                        // 等待 dispatch semaphore
                        // 直到 dispatch semaphore 的计数值达到大于等于1
                        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                        
                        // 大于等于1 所以讲dispatch semaphore 的技术值减1
//                        dispatch_semaphore_wait 函数执行返回
                        [mutArray addObject:[NSNumber numberWithInt:i]];
                        
                        // 通过 dispatch_semaphore_signal 函数
                        // 将 dispatch semaphore 的技术值增加1
                        dispatch_semaphore_signal(semaphore);
                    });
                }
                
                NSLog(@"%@", mutArray);
#endif
                
                
            }
        }
            break;
            
        default:
            break;
    }
}

@end
