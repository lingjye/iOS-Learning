//
//  MKViewController.m
//  MKMediator
//
//  Created by lingjye on 06/14/2019.
//  Copyright (c) 2019 lingjye. All rights reserved.
//

#import "MKViewController.h"
#import "MKMediator+ModuleA.h"
#import "MKMediator+ModuleB.h"

@interface MKViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) MKMediator *mediator;

@end

@implementation MKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Exmaple";

    [self.view addSubview:self.tableView];
    
    self.mediator.factoryClass(@"MK").factory(@"logging");
    [self.mediator dispatch:MKMediatorAction.sClsMethod(@"MK logging")];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = self.datas[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIViewController *viewController =
            [self.mediator moduleAViewControllerWithCallback:^(NSString *_Nonnull result) {
                NSLog(@"%@", result);
                [self.mediator notifyObservers:@"next"];
            }];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.row == 1) {
//        UIViewController *viewController = [self.mediator moduleBViewControllerWithParams:@{ @"title" : @"ModuleB" }];
        UIViewController *viewController = self.mediator.dispatch(MKMediatorAction.sClsMethod(@"ModuleB viewController").params([@{ @"title" : @"ModuleB" } mutableCopy]));
        [self.navigationController pushViewController:viewController animated:YES];
        
        self.mediator.dispatch(MKMediatorAction.sClsMethod(@"MKViewController logging").params(MKMediatorParameters.create.key(@"selectedIndex").value(@(indexPath.row)).dictionary));
    }
}

- (void)logging:(NSDictionary *)params {
    NSLog(@"logging: %@", params);
}

- (void)middleware:(NSDictionary *)params {
    NSLog(@"middleware: %@", params);
}

- (void)nextPage:(NSDictionary *)params {
    NSLog(@"下一页%@", params);
}

- (void)next:(NSDictionary *)params {
    NSLog(@"下一步%@", params);
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSArray *)datas {
    if (!_datas) {
        _datas = @[ @"moduleA", @"moduleB" ];
    }
    return _datas;
}

- (MKMediator *)mediator {
    if (!_mediator) {
        _mediator = [[MKMediator alloc] init];
        _mediator.observerWithIdentifier(@"next")
        .observer(MKMediatorAction.sClsMethod(@"MKViewController nextPage").params(MKMediatorParameters.create.key(@"key").value(@"value").dictionary))
            .observer(MKMediatorAction.sClsMethod(@"MKViewController next"));
        [_mediator configMiddlewares];
    }
    return _mediator;
}

@end
