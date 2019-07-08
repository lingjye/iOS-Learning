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
    dispatch_source_t _timer;
}

@end

@implementation MTLRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"GCD";
    
    _datas = @[ @[ @"Serial Dispatch Queue",
                   @"Concurrent Dispatch Queue" ],
                    ];
    
//    [self dispatchGroup];
//    [self dispatchBarrierAsync];
//    [self dispatchApply];
//    [self dispatchSuspendResume];
//    [self dispatchSemaphore];
//    [self dispatchIO];
//    [self dispatchSourceAyncRead];
    [self dispatchSourceTimer];
}

- (IBAction)itemClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.tableView.editing = !self.tableView.editing;
}

- (void)dispatch {
    // 调用后台线程方法
    [self performSelectorInBackground:@selector(doSomeWork) withObject:nil];
}

- (void)doSomeWork {
    // 后台线程处理方法
    // 执行耗时操作
    
    // 执行耗时操作完成，返回主线程处理
    [self performSelectorOnMainThread:@selector(doneWork) withObject:nil waitUntilDone:NO];
}

- (void)doneWork {
    // 需要主线程可以处理的操作
    // 例如刷新UI等
}

- (void)createDispatchQueue {
    /**
     创建Dispatch Queue
     @label "com.test.mySerialDispatchQueue" 第一个参数 指定Serial Diaptch Queue的名称， 推荐使用bundleID这种域名倒写。
     会在Xcode和Instruments调试器中作为Dispatch Queue的名称显示，并且也会出现在程序崩溃的CrashLog中（崩溃日期）。
     可以 NULL也可以，但不推荐
     
     @attr 如果生成Serial Dispatch Queue,将第二个参数指定为NULL， 或者DISPATCH_QUEUE_SERIAL（DISPATCH_QUEUE_SERIAL的宏定义也是NULL）
     如果生成Concurrent Dispatch Queue，将第二个参数指定为DISPATCH_QUEUE_DISPATCH_QUEUE_CONCURRENT
     */
    dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create("com.test.mySerialDispatchQueue", NULL);
    dispatch_queue_t myConcurrentDispatchQueue = dispatch_queue_create("com.test.mySerialDispatchQueue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_release(mySerialDispatchQueue);
//    dispatch_release(myConcurrentDispatchQueue);
    dispatch_async(myConcurrentDispatchQueue, ^{
        
    });
    
    dispatch_async(myConcurrentDispatchQueue, ^{
        
    });
}

- (void)mainAndGlobalDispatchQueue {
    // 获取主线程Main Dispatch Queue方法
    dispatch_queue_t mainDispatchQueue = dispatch_get_main_queue();
    
    // 获取Global Dispatch Queue(高优先级)方法
    dispatch_queue_t globalDispatchQueueHigh = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    // 获取Global Dispatch Queue(默认优先级)方法
    dispatch_queue_t globalDispatchQueueDefault = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 获取Global Dispatch Queue(低优先级)方法
    dispatch_queue_t globalDispatchQueueLow = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    
    // 获取Global Dispatch Queue(后台优先级)方法
    dispatch_queue_t globalDispatchQueueBackground = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    // 在默认优先级的Global Dispatch Queue中执行Block
    dispatch_async(globalDispatchQueueDefault, ^{
        // 执行耗时操作或可并行执行的处理
        
        // 在Main Dispatch Queue中执行Block
        dispatch_async(mainDispatchQueue, ^{
            // 只能在主线程中进行的操作
        });
    });
}

- (void)dispatchSetTargetQueue {
    dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create("com.test.mySerialDispatchQueue", NULL);
    dispatch_queue_t globalDispatchQueueBackground = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    // 第一个参数不能是Main Dispatch Queue和Global Dispatch Queue
    dispatch_set_target_queue(mySerialDispatchQueue, globalDispatchQueueBackground);
}

- (void)dispatchAfter {
    
    /**
     * dispatch_time 计算相对时间 dispatch_walltimey函数用于计算绝对时间
     * NSEC_PER_SEC是秒为单位，以毫秒为单位使用NSEC_PER_MSEC
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 等待至少3s后执行的操作
    });
}

- (void)dispatchGroup {
    // 创建Dispatch Group
    dispatch_group_t group = dispatch_group_create();
    // 获取一个默认优先级的Global Dispatch Queue
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 使用dispatch_group_async方法将Queue指定到Group中管理
    dispatch_group_async(group, queue, ^{
        NSLog(@"1");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"2");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"3");
    });
    
    // 使用dispatch_group_notify将group加入监视，等待group中的所有任务处理结束时调用该方法
    // 所有block执行完成，调用该方法打印“4”
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"4");
    });
    
    // 除了dispatch_group_notify还可以使用dispatch_group_wait函数，此函数仅等待所有处理执行完毕
    // 第二个参数可指定dispatch_time_t类型的值，代表等待时间
    // DISPATCH_TIME_FOREVER代表永远等待
    // DISPATCH_TIME_NOW代不用一直等待
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    // 如果没有使用DISPATCH_TIME_FOREVER，可使用dispatch_group_wait的返回值判断任务是否全部执行完成
    // ull代表是unsigned long long类型
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
    long result = dispatch_group_wait(group, time);
    if (result == 0) {
        // Dispatch Group的所有任务处理完成
    } else {
        // Dispatch 的某些处理还在执行，此处result>=1
    }
    
}

- (void)dispatchBarrierAsync {
    // 创建Concurrent Dispatch Queue， 执行多个并行读取操作
    dispatch_queue_t queue = dispatch_queue_create("com.test.DispatchBarrierAsync", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
       // read1
        NSLog(@"read1:%@", self.title);
    });
    dispatch_async(queue, ^{
        // read2
        NSLog(@"read2:%@", self.title);
    });
    dispatch_async(queue, ^{
        // read3
        NSLog(@"read3:%@", self.title);
    });
    // dispatch_barrier_async函数会等待追加到Concurrent Dispatch Queue上的并行执行的处理全部结束后执行
    dispatch_barrier_async(queue, ^{
       // write 保证后面的异步执行访问不错乱
        self.title = @"dispatch_barrier_async";
        NSLog(@"write:%@", self.title);
    });
    dispatch_async(queue, ^{
        // read4
        NSLog(@"read4:%@", self.title);
    });
    dispatch_async(queue, ^{
        // read5
        NSLog(@"read5:%@", self.title);
    });
}

- (void)dispatchSync {
    // 死锁1 当前执行的任务处于主线程中，该函数会一直等待主线程结束，造成死锁
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        NSLog(@"死锁");
    });
    
    // 死锁2
    // dispatch_async不会一直等待
    dispatch_async(queue, ^{
        // 此处死锁同死锁1
        dispatch_sync(queue, ^{
            NSLog(@"死锁");
        });
    });
    
    // 死锁3
    // 使用Serial Dispatch Queue引起死锁
    dispatch_queue_t serialDispatchQueue = dispatch_queue_create("com.test.serialDispatchQueue", NULL);
    dispatch_async(serialDispatchQueue, ^{
        dispatch_sync(queue, ^{
            NSLog(@"死锁");
        });
    });
    
}

- (void)dispatchApply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 第一个参数代表重复执行次数， 第二个参数为追加对象的Dispatch Queue，第三个参数为追加的处理，并将当前执行任务执行下标作为参数传入Block
    dispatch_apply(10, queue, ^(size_t index) {
        // 执行10次，并发执行
        NSLog(@"%zu", index);
    });
    // 该打印方法一定最后执行， 因为dispatch_apply函数会等待全部处理执行完成
    NSLog(@"结束");
    
    // 配合dispatch_async使用
    dispatch_async(queue, ^{
        dispatch_apply(10, queue, ^(size_t index) {
            // 处理操作
            NSLog(@"%zu", index);
        });
        
        // dispatch_apply函数处理完毕后，在Main Dispatch Queue中非同步执行
        dispatch_async(dispatch_get_main_queue(), ^{
            // 主线程操作
            NSLog(@"结束");
        });
    });
    
}

- (void)dispatchSuspendResume {
    dispatch_queue_t queue = dispatch_queue_create("com.test.dispatchSuspendResume", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"等待3s前");
        sleep(3);
        // 已开始任务不会被挂起
        NSLog(@"等待3s后");
    });
    dispatch_async(queue, ^{
        NSLog(@"另一个等待3s前");
        sleep(3);
        // 这个打印方法会在上次打印后至少间隔6s后打印
        // 本次未开始，被挂起
        NSLog(@"另一个等待3s后");
    });
    //延时一秒
    sleep(1);
    //挂起队列
    NSLog(@"开始挂起");
    dispatch_suspend(queue);
    //延时5秒
    NSLog(@"等待5s");
    sleep(5);
    //5s后恢复队列
    NSLog(@"恢复");
    dispatch_resume(queue);
}

- (void)dispatchSemaphore {
    NSMutableArray *mutArray = [NSMutableArray array];
    // dispatch semaphore 的计数初始值设定为1
    // 保证可访问 NSMutableArray 类对象的线程同时只能有一个
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    for (int i = 0; i < 100; i++) {
        dispatch_async(queue, ^{
            // 等待 dispatch semaphore
            // 直到 dispatch semaphore 的计数值达到大于等于1
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            // 大于等于1 所以讲dispatch semaphore 的技术值减1
            //                        dispatch_semaphore_wait 函数执行返回
            [mutArray addObject:[NSNumber numberWithInt:i]];
            
            // 通过 dispatch_semaphore_signal 函数
            // 将 dispatch semaphore 的计数值增加1
            dispatch_semaphore_signal(semaphore);
        });
    }
    
    NSLog(@"%@", mutArray);
}

//- (instancetype)dispatchOnce {
//    static dispatch_once_t onceToken;
//    static MysingleTon *singleTon;
//    dispatch_once(&onceToken, ^{
//        singleTon = [[NSObject alloc] init];
//    });
//    return singleTon;
//}

- (void)dispatchIO {
    // 获取Global Dispatch Queue
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    // 将文件分为三块读取
//    dispatch_sync(queue, ^{
//        // 读取0~8191字节
//    });
//    dispatch_sync(queue, ^{
//        // 读取8192~16383字节
//    });
//    dispatch_sync(queue, ^{
//        // 读取16384~24575字节
//    });
    
    // 分割读取数据通过使用Dispatch Data
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DispatchIOFile" ofType:@"txt"];
#if 0
    // 异步串行读取 Serial Dispatch Queue
    dispatch_queue_t queue = dispatch_queue_create("PipeQ", NULL);
    dispatch_fd_t fd = open([path UTF8String], O_RDONLY, 0);
    dispatch_io_t pipe_channel = dispatch_io_create(DISPATCH_IO_STREAM, fd, queue, ^(int error) {
        close(fd);
    });
    //设置读取大小
    size_t water = 1024;
    dispatch_io_set_low_water(pipe_channel, water);
    dispatch_io_set_high_water(pipe_channel, water);

    long long fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    NSMutableData *totalData = [[NSMutableData alloc] init];

    dispatch_io_read(pipe_channel, 0, fileSize, queue, ^(bool done, dispatch_data_t _Nullable data, int error) {
        if (error == 0) {
            size_t len = dispatch_data_get_size(data);
            if (len > 0) {
                [totalData appendData:(NSData *)data];
            }
        }
        if (done) {
            NSString *str = [[NSString alloc] initWithData:totalData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", str);
        }
    });
#endif
    // 异步并行读取文件 Concurrent Dispatch Queue
    dispatch_queue_t queue = dispatch_queue_create("PipeQ", DISPATCH_QUEUE_CONCURRENT);
    dispatch_fd_t fd = open([path UTF8String], O_RDONLY);
    dispatch_io_t pipe_channel = dispatch_io_create(DISPATCH_IO_RANDOM, fd, queue, ^(int error) {
        close(fd);
    });
    off_t currentSize = 0;
    long long fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    //设置每次读取大小
    size_t offset = 1024;
    // 创建Dispatch Group
    dispatch_group_t group = dispatch_group_create();
    // 创建长度为文件长度的空可变data，等待数据读取到之后替换
    NSMutableData *totalData = [[NSMutableData alloc] initWithLength:fileSize];
    for (; currentSize <= fileSize; currentSize += offset) {
        dispatch_group_enter(group);
        dispatch_io_read(pipe_channel, currentSize, offset, queue, ^(bool done, dispatch_data_t _Nullable data, int error) {
            if (error == 0) {
                size_t len = dispatch_data_get_size(data);
                if (len > 0) {
                    const void *bytes = NULL;
                    (void)dispatch_data_create_map(data, (const void **)&bytes, &len);
                    // 替换数据
                    [totalData replaceBytesInRange:NSMakeRange(currentSize, len) withBytes:bytes length:len];
                }
            }
            if (done) {
                dispatch_group_leave(group);
            }
        });
    }
    dispatch_group_notify(group, queue, ^{
        NSString *str = [[NSString alloc] initWithData:totalData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
    });
}

- (void)dispatchSourceAyncRead {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DispatchIOFile" ofType:@"txt"];
    __block size_t total = 0;
    // 要读取的字节数
    long long fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    size_t size = fileSize;
    char *buff = (char *)malloc(size);
    
    dispatch_fd_t fd = open([path UTF8String], O_RDONLY);
    // 设定异步映像
    fcntl(fd, F_SETFL, O_NONBLOCK);
    
    // 获取用于追加事件的Global Dispatch Queue
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 基于READ事件创建Dispatch Source
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, fd, 0, queue);
    // 指定发生READd事件时执行的处理
    dispatch_block_t event_handler = ^{
        // 获取可读取的字节数
        size_t availble = dispatch_source_get_data(source);
        // 从映像中读取
        long length = read(fd, buff, availble);
        // 发生错误时取消Dispatch Source
        if (length < 0) {
            // 取消读取
            dispatch_source_cancel(source);
        }
        total += length;
        if (total == size) {
            // buff的处理
            // 处理结束，取消Dispatch Source
            dispatch_source_cancel(source);
            NSString *result = [[NSString alloc] initWithBytes:buff length:size encoding:NSUTF8StringEncoding];
            NSLog(@"%@", result);
            NSLog(@"读取完成");
        }
    };
    dispatch_source_set_event_handler(source, event_handler);
    
    // 指定取消Dispatch Source时的处理
    dispatch_block_t cancel_handler = ^{
        // 释放资源
        free(buff);
        close(fd);
        // 释放Dispatch Source 支持ARC，无需手动释放
//        dispatch_release(source);
        NSLog(@"取消");
    };
    dispatch_source_set_cancel_handler(source, cancel_handler);
    
    // 启动 Dispatch Source
    dispatch_resume(source);
    
}

- (void)dispatchSourceTimer {
    // 指定DISPATCH_SOURCE_TYPE_TIMER,创建Dispatch Source, 指定在Main Dispatch Queue
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    // 定时器每隔3s执行一次,允许延迟1s
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    // 指定执行处理
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"定时器执行");
        // 取消Dispatch Source
//        dispatch_source_cancel(timer);
    });

    // 指定取消事件
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"取消");
    });

    dispatch_resume(timer);
    // 必须设置为属性才有用
    _timer = timer;
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
                        // 将 dispatch semaphore 的计数值增加1
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
