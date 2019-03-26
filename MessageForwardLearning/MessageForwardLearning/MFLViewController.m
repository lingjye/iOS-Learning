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
#import "NSObject+MSLPerformSelector.h"

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
        }
            break;
        case 4: {
            
        }
            break;
        default:
            break;
    }
}

- (SEL)printParam0:(NSString *)param0 param1:(NSString *)param1 param2:(NSString *)param2 {
    NSLog(@"%@---%@---%@", param0, param1, param2);
//    return MFLDog.class;
    return @selector(nihao);
}

@end
