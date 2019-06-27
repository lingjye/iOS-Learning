//
//  ViewController.m
//  OpenGL
//
//  Created by txooo on 2019/2/25.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewController.h"
#import "GLTViewController.h"
#import "GLESViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"LearningOpenGLES";
    // Do any additional setup after loading the view.
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    //    [self.view addSubview:view];
    //    UIView *superView = [self findSuperView:view];
    //    NSLog(@"%@", superView);
    //    NSLog(@"%@", view);
    //    view.backgroundColor = UIColor.redColor;
    //    superView.backgroundColor = UIColor.yellowColor;
    [self.view addSubview:self.tableView];
}

- (UIView *)findSuperView:(UIView *)view {
    for (; view; view = view.superview);
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        GLTViewController *viewController = [[GLTViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        GLESViewController *viewController = [[GLESViewController alloc] init];
        viewController.index = indexPath.row;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [@[
            @"GLViewController",
            @"RenderTemplate",
            @"Triangle",
        ] mutableCopy];
    }
    return _datas;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
