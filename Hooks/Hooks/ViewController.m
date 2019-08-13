//
//  ViewController.m
//  Hooks
//
//  Created by txooo on 2019/7/30.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "fishhook/fishhook.h"
#import <dlfcn.h>
#import "libffi/ffi.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface Test : NSObject

@end

@implementation Test

// objc function
// 计算两数之和
- (int)fooWithBar:(int)bar baz:(int)baz {
    return bar + baz;
}

@end


@interface ViewController ()

@end

@implementation ViewController

#pragma mark 方式一： runtime
static inline void swizzleMethod(Class cls, SEL originSelector, SEL swizzledSelector) {
    Method originMethod = class_getInstanceMethod(cls, originSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    // 添加原Selector是为了做一层保护，如果这个类没有实现原始方法"originalSel" ，但其父类实现了，那么class_getInstanceMethod会返回父类的方法，使用 method_exchangeImplementations实际上替换的是父类的方法。之所以这里的SEL是orginSelector，是因为将交换后方法的实现映射到原方法调用中
    BOOL result = class_addMethod(cls, originSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (result) {
        class_replaceMethod(cls, swizzledSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, swizzledMethod);
    }
};

+ (void)load {
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSel = @selector(viewWillAppear:);
        SEL swizzledSel = @selector(lj_viewWillAppear:);
        swizzleMethod(self, originSel, swizzledSel);
    });
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    NSLog(@"%s", __func__);
//}

- (void)lj_viewWillAppear:(BOOL)animated {
    [self lj_viewWillAppear:animated];
    NSLog(@"%s", __func__);
}

#pragma mark 方式二： fishhook
static int (*orig_close)(int);
static int (*orig_open)(const char *, int, ...);

int my_close(int fd) {
    printf("Calling real close(%d)\n", fd);
    // 调用原函数
    return orig_close(fd);
}

int my_open(const char *path, int oflag, ...) {
    va_list ap = {0};
    mode_t mode = 0;
    // O_CREAT 如果不存在则创建
    if ((oflag & O_CREAT) != 0) {
        // mode 只适用于 O_CREAT
        va_start(ap, oflag);
        mode = va_arg(ap, int);
        va_end(ap);
        printf("Calling real open(%s, %d, %d)\n", path, oflag, mode);
        return orig_open(path, oflag, mode);
    } else {
        printf("Calling real open(%s, %d)\n", path, oflag);
        return orig_open(path, oflag, mode);
    }
}

#pragma mark 方式三： libffi

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

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    ViewController *viewController = [super allocWithZone:zone];
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        NSLog(@"调用ViewDidLoad");
    }];
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createButtonWithFlag:0];
    [self createButtonWithFlag:1];
    [self createButtonWithFlag:2];
}

- (void)createButtonWithFlag:(int)flag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:[NSString stringWithFormat:@"button_%d", flag] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 100 + flag;
    button.frame = CGRectMake(100, 100 + 100 * flag, 100, 50);
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)button {
    NSInteger tag = button.tag - 100;
    if (tag == 0) {
        [self viewWillAppear:YES];
    } else if (tag == 1) {
        // hook C函数，第一个参数是一个rebinding类型结构体数组，第二个参数是第一个参数结构体数组的长度
        rebind_symbols((struct rebinding[2]){{"close", my_close, (void *)&orig_close}, {"open", my_open, (void *)&orig_open}}, 2);
        // 获取二进制文件进行读取
        NSString *binaryPath = [[NSBundle mainBundle] pathForResource:@"Hooks" ofType:@""];
        const char *path = [binaryPath cStringUsingEncoding:NSUTF8StringEncoding];
        int fd = open(path, O_CREAT);
        uint32_t magic_number = 0;
        // 读取4个字节
        read(fd, &magic_number, 4);
        printf("Mach-O Magic Number: %x \n", magic_number);
        close(fd);
    } else if (tag == 2) {
        testFFICallObjcFunc();
        testFFICallCFunc();
        testFFIClosure();
    }
}

@end

