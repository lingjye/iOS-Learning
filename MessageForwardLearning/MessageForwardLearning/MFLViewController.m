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
            SEL sel = NSSelectorFromString(result);
            [self performSelector:sel withObject:@"hello"];
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

- (SEL)printParam0:(NSString *)param0 param1:(NSString *)param1 param2:(NSString *)param2 {
    NSLog(@"%@ --- %@ --- %@", param0, param1, param2);
    return @selector(nihao:);
}

- (void)nihao:(NSString *)param {
    NSLog(@"%s -- %@", __func__, param);
}

@end
