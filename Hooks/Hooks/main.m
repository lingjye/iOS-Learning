//
//  main.m
//  Hooks
//
//  Created by txooo on 2019/7/30.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    const char *path = argv[0];
    printf("%s", path);
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
