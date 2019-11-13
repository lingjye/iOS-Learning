//
//  ViewController.m
//  KVO
//
//  Created by txooo on 2019/5/15.
//  Copyright © 2019 txooo. All rights reserved.
//
/*
 KVO 实现基于runtime
 1.当类的属性被观察时创建派生类, 重写被观察属性的setter方法, 并在该setter方法内实现真正的通知机制
 2.派生类: NSKVONotifying_Class 手动创建该类后, KVO失效 (可将NSKVONotifying_Person类添加到右侧Target
 Membership下的KVO选中查看) 可查看控制台错误信息:KVO failed to allocate class pair for name
 NSKVONotifying_Person, automatic key-value observing will not work for this class,
 此时可在本类的setter方法手动调用4的两个方法触发KVO

 3.系统将isa(原指向为当前类), 改为指向派生类, 使得setter方法调用派生类的setter方法
 4.在内部调用willChangeValueForKey:(一定会被调用,
 记录旧值)和didChangeValueForKey(改变后调用)方法(顾名思义), 从而调用observeValueForKeyPath:
 ofObject: change: context:
 */

#import "ViewController.h"
#import "Person.h"
#import "NSObject+KVO.h"

@interface ViewController () {
    Person *_person;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    _person = [[Person alloc] init];
//    _person.name = @"小明";
//
//    //    [_person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew |
//    //    NSKeyValueObservingOptionOld context:nil];
//    [_person lj_addObserver:self
//                 forKeyPath:@"name"
//                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
//                    context:nil];
    Man *man = [[Man alloc] init];
    
    
    __block int a = 0;
    while (a <= 5) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            a++;
        });
    }
    NSLog(@"%i", a);
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@", change);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _person.name = @"小红";
}

@end
