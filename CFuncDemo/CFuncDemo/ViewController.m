//
//  ViewController.m
//  CFuncDemo
//
//  Created by txooo on 2019/6/4.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewController.h"
#import <dlfcn.h>
#import <ffi.h>
#import <objc/runtime.h>

@interface Test : NSObject

@end

@implementation Test

// objc function
// 计算两数之和
- (int)fooWithBar:(int)bar baz:(int)baz {
    return bar + baz;
}

@end

// 计算矩形面积
int rectangleArea(int length, int width) {
    printf("Rectangle length is %d, width is %d\n", length, width);
    return length * width;
}

void *testArea() {
    // dlsym 返回rectangleAred函数指针
    void *dlsymFuncPtr = dlsym(RTLD_DEFAULT, "rectangleArea");
    return dlsymFuncPtr;
}

void testFFICallCFunc() {
    // libffi调用c函数
    ffi_cif cif;
    //参数类型指针数组, 根据被调用的函数入参的类型来制定
    ffi_type *argumentTypes[] = {
        &ffi_type_pointer,
        &ffi_type_pointer,
        &ffi_type_sint32,
        &ffi_type_sint32
    };
    //用过ffi_prep_cif 内ffi_prep_cif_core 来设置ffi_cif结构体所需要的数据, 包括ABI
    // 参数个数,参数类型等
    ffi_prep_cif(&cif, FFI_DEFAULT_ABI, 4, &ffi_type_pointer, argumentTypes);
    // 函数参数的设置
    int bar = 123;
    int baz = 456;
    void *args[] = {&bar, &baz};
    // 返回值声明
    int returnValue;

    ffi_call(&cif, testArea(), &returnValue, args);
    NSLog(@"ffi_call: %d", returnValue);
}

void testFFICallObjcFunc() {
    // ffi_call 调用需要准备的模板 ffi_cif
    ffi_cif cif;
    //参数类型指针数组, 根据被调用的函数入参的类型来制定
    ffi_type *argumentTypes[] = {
        &ffi_type_pointer,
        &ffi_type_pointer,
        &ffi_type_sint32,
        &ffi_type_sint32
    };
    //用过ffi_prep_cif 内ffi_prep_cif_core 来设置ffi_cif结构体所需要的数据, 包括ABI
    // 参数个数,参数类型等
    ffi_prep_cif(&cif, FFI_DEFAULT_ABI, 4, &ffi_type_pointer, argumentTypes);

    Test *obj = [Test new];
    SEL selector = @selector(fooWithBar:baz:);
    // 函数参数的设置
    int bar = 123;
    int baz = 456;
    void *argsments[] = {&obj, &selector, &bar, &baz};

    // 函数指针 fn
    IMP imp = [obj methodForSelector:selector];
    // 返回值声明
    int returnValue;
    // ffi_call 所需的ffi_cif,函数指针,返回值,函数参数都准备好, 就可以通过ffi_call进行调用
    ffi_call(&cif, imp, &returnValue, argsments);
    NSLog(@"ffi_call: %d", returnValue);
}

// 定义C函数
// 1. 声明一个两数相乘的函数
void closureCalled(ffi_cif *cif, void *ret, void **args, void *userdata) {
    int bar = *((int *)args[2]);
    int baz = *((int *)args[3]);
    *((int *)ret) = bar * baz;
}

// 2. 定义C函数
void testFFIClosure() {
    ffi_cif cif;
    ffi_type *argumentTypes[] = {
        &ffi_type_pointer,
        &ffi_type_pointer,
        &ffi_type_sint32,
        &ffi_type_sint32
    };
    // 定义模板
    ffi_prep_cif(&cif, FFI_DEFAULT_ABI, 4, &ffi_type_pointer, argumentTypes);
    // 声明一个新的函数指针
    IMP newIMP;
    
    // 分配一个closure关联新声明的函数指针
    ffi_closure *closure = ffi_closure_alloc(sizeof(ffi_closure), (void *)&newIMP);
    
    // ffi_closure 关联cif, closure,函数实体 closureCalled
    ffi_prep_closure_loc(closure, &cif, closureCalled, NULL, NULL);
    
    // 使用Runtime 接口动态地将fooWithBar:barz方法绑定到 closureCalled函数指针上
    Method method = class_getInstanceMethod([Test class], @selector(fooWithBar:baz:));
    method_setImplementation(method, newIMP);
    // after hook
    
    Test *hookObj = [Test new];
    int ret = [hookObj fooWithBar:123 baz:456];
    NSLog(@"ffi_closure: %i", ret);
    
    int ret2 = [hookObj fooWithBar:12 baz:45];
    NSLog(@"result: %i", ret2);
}

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    testFFICallObjcFunc();
    testFFICallCFunc();
    testFFIClosure();
}


@end
