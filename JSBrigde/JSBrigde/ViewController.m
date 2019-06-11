//
//  ViewController.m
//  JSBrigde
//
//  Created by txooo on 2019/4/4.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewController.h"
#import "JSObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createButtonWithIndex:0];
    [self createButtonWithIndex:1];
    [self createButtonWithIndex:2];
    [self createButtonWithIndex:3];
    [self createButtonWithIndex:4];
}

- (void)createButtonWithIndex:(NSInteger)index {
    UIButton *button = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = UIColor.redColor;
        [btn setTitle:@"button" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(10, 100 + 35 * index, 100, 25);
        btn.tag = index;
        btn;
    });
    
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)btn {
    NSInteger idx = btn.tag;
    if (idx == 0) {
        JSContext *content = [[JSContext alloc] init];
        [content evaluateScript:@"var a = 1; var b = 2;"];
        NSInteger sum = [[content evaluateScript:@"a + b"] toInt32];
        NSLog(@"%tu", sum);
    } else if (idx == 1) {
        // 创建JSVirtualMachine对象
        JSVirtualMachine *jsvm = [[JSVirtualMachine alloc] init];
        // 创建jscontext
        JSContext *context = [[JSContext alloc] initWithVirtualMachine:jsvm];
        
        // 解析js脚本
        [context evaluateScript:@"function add(x, y) {\
         return x + y \
         }"];
        // 获得add函数
        JSValue *add = context[@"add"];
        // 传入参数并执行
        JSValue *result = [add callWithArguments:@[@2, @8]];
        // 拿到结果, 转原生NSNumber
        NSLog(@"%@", [result toNumber]);
        // 执行全局函数
        JSValue *globalResult = [[context globalObject] invokeMethod:@"add" withArguments:@[@(3), @(2)]];
        NSLog(@"%@", [globalResult toNumber]);
    } else if (idx == 2) {
        JSContext *context = [[JSContext alloc] init];
        context[@"globalFunc"] = ^{
            NSArray *args = [JSContext currentArguments];
            for (id obj in args) {
                NSLog(@"拿到参数:%@", obj);
            }
            return 3;
        };
        context[@"globalProp"] = @"全部变量字符串";
        NSInteger result = [[context evaluateScript:@"globalFunc(globalProp)"] toInt32];
        NSString *type = [[context evaluateScript:@"typeof globalFunc"] toString];//type的值为"function"
        NSLog(@"%@", type);
        NSLog(@"JS回传参数:%tu", result);
    } else if (idx == 3) {
        JSContext *context = [[JSContext alloc] init];
        context[@"block"] = ^(int x, int y){
            NSArray *args = [JSContext currentArguments];
            for (id obj in args) {
                NSLog(@"拿到参数:%@", obj);
            }
            return x + y;
        };
        NSInteger result = [[context evaluateScript:@"block(3, 4)"] toInt32];
        NSLog(@"JS回传参数:%tu", result);
    } else if (idx == 4) {
        // 将实例传入JSContext
        JSContext *context = [[JSContext alloc] init];
        JSObject *object = [[JSObject alloc] init];
        object.firstName = @"firstName";
        object.lastName = @"lastName";
        
        context[@"object"] = object;
        [context evaluateScript:@"log(object.fullName())"];//调Native方法，打印出person实例的全名
        [context evaluateScript:@"object.sayFullName()"];//提示TypeError，'person.sayFullName' is undefined
        
    }
}


@end
