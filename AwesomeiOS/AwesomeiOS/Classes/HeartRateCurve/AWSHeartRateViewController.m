//
//  AWSHeartRateViewController.m
//  AwesomeiOS
//
//  Created by txooo on 2018/9/12.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import "AWSHeartRateViewController.h"
#import "AWSHeartRateView.h"

@interface AWSHeartRateViewController ()
{
    NSTimer *_timer1;
    NSTimer *_timer2;
    NSInteger _refreshIndex, _translationIndex;
    NSInteger _refreshCoordinateInMoniterX, _translationCoordinateInMoniterX;
}
@property (nonatomic, strong) AWSPointManager *pointManeger;
@property (nonatomic, strong) AWSHeartRateView *heartRateView;
@property (nonatomic, strong) AWSHeartRateView *translationRateView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation AWSHeartRateViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_timer1 invalidate];
    [_timer2 invalidate];
    _timer1 = nil;
    _timer2 = nil;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.heartRateView];
    [self.view addSubview:self.translationRateView];
    
    [self loadLocalData];
    
    [self inputDataWithInterval:0.01];
}

- (void)loadLocalData {
    NSString *localPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"txt"];
    NSString *fileString = [NSString stringWithContentsOfFile:localPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [fileString componentsSeparatedByString:@","];
    [self.dataArray addObjectsFromArray:array];
    
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *number = @(-[obj integerValue] + 2048);
        self.dataArray[idx] = number;
    }];
}

- (void)inputDataWithInterval:(CGFloat)interval {
    _timer1 = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(refreshHeaderRateView) userInfo:nil repeats:YES];
    _timer2 = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(refreshTranslationRateView) userInfo:nil repeats:YES];
}

- (void)refreshHeaderRateView {
    CGPoint point = [self bubbleRefreshPoint];
    [self.pointManeger addPointAsRefreshChangeForm:point];
    [self.heartRateView animationWithPoints:self.pointManeger.refreshPointInstance pointsCount:self.pointManeger.numberOfRefreshElements];
}

- (void)refreshTranslationRateView {
    CGPoint point = [self bubbleTranslationPoint];
    [self.pointManeger addPointASTranslationChangeForm:point];
    [self.translationRateView animationWithPoints:self.pointManeger.translationPointInstance pointsCount:self.pointManeger.numberOfTanslationElements];
}

#pragma mark Data
- (CGPoint)bubbleRefreshPoint {
    //求余数
    _refreshIndex %= [self.dataArray count];
    //x坐标
    //坐标点
    CGPoint targetPointToAdd = CGPointMake(_refreshCoordinateInMoniterX, [self.dataArray[_refreshIndex ] integerValue] * 0.5 + 120);
    //移动坐标
    _refreshCoordinateInMoniterX += 1;
    _refreshCoordinateInMoniterX %= (int)(CGRectGetWidth(self.heartRateView.frame));

    _refreshIndex++;

    return targetPointToAdd;
}

- (CGPoint)bubbleTranslationPoint {
    //求余数
    _translationIndex %= [self.dataArray count];

    CGPoint targetPointToAdd = CGPointMake(_translationCoordinateInMoniterX, [self.dataArray[_translationIndex] integerValue] * 0.5 + 120);
    _translationCoordinateInMoniterX += 1;
    _translationCoordinateInMoniterX %= (int)(CGRectGetWidth(self.translationRateView.frame));

    _translationIndex++;

    return targetPointToAdd;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AWSHeartRateView *)heartRateView {
    if (!_heartRateView) {
        _heartRateView = [[AWSHeartRateView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.view.bounds) - 20, 200)];
    }
    return _heartRateView;
}

- (AWSHeartRateView *)translationRateView {
    if (!_translationRateView) {
        _translationRateView = [[AWSHeartRateView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.heartRateView.frame) + 20, CGRectGetWidth(self.heartRateView.frame), 200)];
    }
    return _translationRateView;
}

- (AWSPointManager *)pointManeger {
    if (!_pointManeger) {
        _pointManeger = [[AWSPointManager alloc] init];
    }
    return _pointManeger;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
