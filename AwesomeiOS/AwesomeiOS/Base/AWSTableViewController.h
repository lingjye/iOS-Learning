//
//  AWSTableViewController.h
//  AwesomeiOS
//
//  Created by txooo on 2018/9/12.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import "AWSViewController.h"
#import "AWSTableViewControllerProtocol.h"

@interface AWSTableViewController : AWSViewController<UITableViewDelegate, UITableViewDataSource, AWSTableViewControllerProtocol>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end
