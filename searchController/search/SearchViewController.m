//
//  searchController.m
//  search
//
//  Created by txooo on 2018/12/4.
//  Copyright © 2018 txooo. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "MJRefresh.h"

@interface SearchViewController ()<UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchResultViewController *resultViewController;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SearchViewController

static NSString *const CellID = @"cellID";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBarTintColor:UIColor.redColor];
#pragma mark 注意, 以下属性必须重新设置为默认值
    if (@available(ios 11.0,*)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBarTintColor:UIColor.whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"搜索";
#pragma mark 注意, 以下属性必须重新设置为默认值
    self.edgesForExtendedLayout = UIRectEdgeAll;

    self.definesPresentationContext = YES;
    [self.view addSubview:self.tableView];
    
    //适配iOS 11,在 `iOS 11`环境中UISearchBar不是添加到UISearchControllerView中 而是被添加到了 导航栏中了
//    if (@available(iOS 11, *)) {
//        self.navigationItem.searchController = self.searchController;
//        self.navigationItem.hidesSearchBarWhenScrolling = NO;
//    } else {
        self.tableView.tableHeaderView = self.searchController.searchBar;
//    }
    
    [self customSearchBarStyle];
    [self refresh];
    
}

- (void)refresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.dataArray removeObjectsInRange:NSMakeRange(0, 1)];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.dataArray addObject:@"a"];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
        });
    }];
    /// 注意:下拉刷新未停止时, 点击搜索框会造成偏移
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma UISearchControllerDelegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"%@", searchController.searchBar.text);
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *array = [NSMutableArray new];
    for (NSString *obj in self.dataArray) {
        if ([obj isEqualToString:searchText]) {
            [array addObject:obj];
        }
    }
    self.resultViewController.dataArray = array;
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    NSLog(@"将弹出");
    [self.tableView.mj_header endRefreshing];
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    NSLog(@"将消失");
}

#pragma mark LazyLoad
- (UISearchController *)searchController {
    if (!_searchController) {
        _resultViewController = [[SearchResultViewController alloc] init];
        _searchController = [[UISearchController alloc] initWithSearchResultsController:_resultViewController];
        //当搜索框激活时, 是否隐藏导航条 default is YES;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        //当搜索框激活时, 是否添加一个透明视图 default is YES
        _searchController.dimsBackgroundDuringPresentation = YES;
        _searchController.searchBar.placeholder = @"请输入搜索内容";
        _searchController.delegate = self;
        _searchController.searchResultsUpdater = self;
        
        //背景
//        [_searchController.searchBar setBackgroundColor:[UIColor redColor]];
//        [_searchController.searchBar setTintColor:UIColor.whiteColor];
        [_searchController.searchBar setBackgroundImage:[self imageWithColor:[UIColor groupTableViewBackgroundColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [_searchController.searchBar setBackgroundImage:[self imageWithColor:[UIColor groupTableViewBackgroundColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefaultPrompt];
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}

//自定义SearchBar 样式
- (void)customSearchBarStyle{
    //将Cancel 修改为 【取消】
    if (@available(iOS 9.0, *)) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"取消"];
    } else {
        // Fallback on earlier versions
//        [UIBarButtonItem appearanceForTraitCollection:[UITraitCollection ]];
    }
    //    [self.searchCtrl.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    
    //修改搜索框的位置
//    [self.searchController.searchBar setPositionAdjustment:UIOffsetMake(100.f, 0.f) forSearchBarIcon:UISearchBarIconSearch];
    
    //修改取消文字颜色以及光标的颜色
//    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    
    //bar's background iOS 11 环境中貌似不起作用
    //    self.searchController.searchBar.barTintColor = [UIColor yellowColor];
    
    //为searchBar 设置图片
//    [self.searchController.searchBar setImage:[UIImage imageNamed:@"voice_gray"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    [self.searchController.searchBar setImage:[UIImage imageNamed:@"message_gray"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
//    [self.searchController.searchBar setImage:[UIImage imageNamed:@"message_gray"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];
    
    //修改文字样式（在iOS 11 环境中拿不到该属性）
    UITextField *textField = [self.searchController.searchBar valueForKey:@"_searchField"];
    textField.textColor = [UIColor yellowColor];
    textField.font = [UIFont systemFontOfSize:15.f];
    
    //占位文字 ios11失效
    [textField setValue:[UIColor greenColor] forKeyPath:@"_placeholderLabel.textColor"];
    //设置属性字符串，设置好想要的颜色和文本 ios11可以使用
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"默认文本" attributes:[NSDictionary dictionaryWithObject:UIColor.cyanColor forKey:NSForegroundColorAttributeName]];
    if (@available(iOS 9.0, *)) {
        [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setAttributedPlaceholder:attributedString];
    } else {
        // Fallback on earlier versions
    }

    //取消上下两条线
    for (UIView *view in self.searchController.searchBar.subviews.firstObject.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view setBackgroundColor:UIColor.blueColor];
        }
    }

    if (@available(iOS 11, *)) {
        for (UIImageView *view in textField.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UISearchBarSearchFieldBackgroundView")]) {
                view.backgroundColor = UIColor.blueColor;
                view.layer.cornerRadius = 18;
            }

        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%@", [NSValue valueWithCGPoint:scrollView.contentOffset]);
}

- (UIImage*)imageWithColor:(UIColor*)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"1", @"2", @"3", nil];
    }
    return _dataArray;
}

@end
