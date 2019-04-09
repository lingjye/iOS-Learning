//
//  ViewController.m
//  MeiTu
//
//  Created by txooo on 2019/4/3.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewController.h"

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
    
    
}


@end
