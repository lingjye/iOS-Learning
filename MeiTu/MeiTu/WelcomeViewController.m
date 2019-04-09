//
//  WelcomeViewController.m
//  Zhuan
//
//  Created by txooo on 16/1/11.
//  Copyright © 2016年 领琾. All rights reserved.
//

#import "WelcomeViewController.h"
#import "ViewController.h"
#import "MTLImageHelper.h"

#define WelCome_ImageCount 4

@interface WelcomeViewController ()<UIScrollViewDelegate>
{
    UIView *pageView;
}

@end

@implementation WelcomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏状态栏
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加UISrollView
    [self setupScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  添加UISrollView
 */
-(void)setupScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    
    //2.添加图片
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    for (NSInteger index = 0; index < WelCome_ImageCount; index++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        //设置图片
        NSString *name = [NSString stringWithFormat:NSLocalizedString(@"第%tu页", nil),index+1];
        imageView.image = [UIImage imageNamed:name];
        //设置frame
        CGFloat imageX = index * imageW;
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        [scrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        //在最后一个图片上面添加按钮
        if (index == WelCome_ImageCount-1) {
            [self setupLastImageView:imageView];
        }
    }
    //    3.设置滚动内容的尺寸
    scrollView.contentSize = CGSizeMake(imageW * WelCome_ImageCount, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    
}

//将内容添加到最后一个图片
-(void)setupLastImageView:(UIImageView *)imageView {
    //    0.imageView默认是不可点击的 将其设置为能跟用户交互
    imageView.userInteractionEnabled=YES;
    //1.添加开始按钮
    UIButton *startButton=[[UIButton alloc] init];
    //2.设置frame
    CGFloat centerX=imageView.frame.size.width*0.5;
    CGFloat centerY=imageView.frame.size.height*0.75;
    startButton.center=CGPointMake(centerX, centerY);
    startButton.frame=CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    [startButton addTarget:self action:@selector(startButton:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startButton];
}

-(void)startButton:(UIButton *)button{
//    [self doAnimation];
//    ViewController *viewController = [[ViewController alloc] init];
//    [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
    NSString *key = @"CFBundleShortVersionString";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    [defaults setObject:currentVersion forKey:key];
    [defaults synchronize];
    
//    [self resetRootViewController:viewController];
    [MTLImageHelper animationRotateAndScaleEffects:self.view];
}

- (void)doAnimation {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.type = @"reveal";
    animation.subtype = @"fromRight";
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"animation"];
    [[UIApplication sharedApplication].keyWindow.layer removeAnimationForKey:@"animation"];
}

- (void)resetRootViewController:(UIViewController *)rootViewController {
    typedef void (^Animation)(void);
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    rootViewController.modalTransitionStyle =     UIModalTransitionStyleCrossDissolve;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        window.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
    };
        
    [UIView transitionWithView:window
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];
}

#pragma mark -scroll代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    1.取出水平方向上滚动的距离
    CGFloat offsetX=scrollView.contentOffset.x;
    //2.求出页码
    double pageDouble=offsetX/scrollView.frame.size.width;
    int pageInt=(int)(pageDouble+0.5);
    if (pageInt > 2) {
        pageView.hidden = YES;
    }else{
        pageView.hidden = NO;
    }
}

@end
