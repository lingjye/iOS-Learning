//
//  ViewController.m
//  MeiTu
//
//  Created by txooo on 2019/4/3.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewController.h"
#import <mach/mach.h>

typedef struct SMStackFrame {
    const struct SMStackFrame *const previous;
    const uintptr_t return_address;
} SMStackFrame;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColor.greenColor;
    
    struct mach_task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kl = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &size);
    float used_mem = info.resident_size;
    // 实际内存
    struct task_vm_info info_phy;
    mach_msg_type_number_t size_phy = sizeof(info_phy);
    kern_return_t kl_phy = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info_phy, &size_phy);
    float phy = info_phy.phys_footprint;
    NSLog(@"使用了 %f MB 内存, %d--%d, 实际: %f MB", used_mem / 1024.0f / 1024.0f, kl, kl_phy, phy / 1024.0f / 1024.0f);
}


@end
