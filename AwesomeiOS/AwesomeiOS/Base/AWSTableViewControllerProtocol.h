//
//  AWSTableViewControllerProtocol.h
//  AwesomeiOS
//
//  Created by txooo on 2018/9/12.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AWSTableViewControllerProtocol <NSObject>

@optional

- (void)configTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
