//
//  ViewController.m
//  MessageForwardLearning
//
//  Created by txooo on 2019/3/26.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MFLViewController.h"
#import "MFLAnimal.h"
#import "MFLPig.h"
#import "MFLDog.h"
#import "MFLCat.h"
#import "MFLParrot.h"
#import "NSObject+MSLPerformSelector.h"
#import "MFLParrot+Animal.h"
#import "NSObject+Animal.h"

@interface MFLViewController ()

@end

@implementation MFLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 逗号表达式
    int a, b, c;
    a = 1;
    b =2;
    c = 12 + ((void)(a=3), b + a);
    printf("a=%d, b=%d, c=%d, \n", a, b, c);
    // goto语句
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            if (i + j == 10) {
                goto filed;
            }
        }
    }
    
filed:
    printf("123\n");
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            MFLPig *pig = [[MFLPig alloc] init];
            [pig sleep];
            [MFLPig sleep];
        }
            break;
        case 1: {
            MFLDog *dog = [[MFLDog alloc] init];
            [dog eat];
            [dog run];
        }
            break;
        case 2: {
            MFLCat *cat = [[MFLCat alloc] init];
            [cat eat];
            [cat run];
        }
            break;
        case 3: {
            id result = [self performSelector:@selector(printParam0:param1:param2:) withObjects:@[@"1", @2, @"3"]];
            NSLog(@"%@", result);
        }
            break;
        case 4: {
            MFLParrot *parrot = [[MFLParrot alloc] init];
            [parrot fly];
            // 调用方法
            // 1 或者给NSObject添加分类, 所有继承自NSObject类的子类都乐意调用其中方法
            [parrot sleep];
            // 在MFLParrot.h或分类中声明 添加关联
            [parrot sing];
            parrot.wingNumber = 2;
            NSLog(@"Parrot wing number: %tu", parrot.wingNumber);
            //
            // 2 performSelector
            // SEL eat = NSSelectorFromString(@"eat");
            // [parrot performSelector:eat];
            // 3 强转
            [(MFLAnimal*)parrot run];
            
            MFLAnimal *animal = [[MFLAnimal alloc] init];
            [animal sleep];
            
        }
            break;
        default:
            break;
    }
}

- (id)printParam0:(NSString *)param0 param1:(NSString *)param1 param2:(NSString *)param2 {
    NSLog(@"%@ --- %@ --- %@", param0, param1, param2);
    return @"你好";
}

@end
