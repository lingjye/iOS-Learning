//
//  AWSPaintView.m
//  AwesomeiOS
//
//  Created by txooo on 2018/9/18.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import "AWSPaintView.h"
#import "AWSPaintSelectColorEasyView.h"
#import "AWSPaintSelectColorPickerView.h"

@interface AWSPaintView ()<AWSPaintSelectColorEasyViewDelegate, AWSPaintSelectColorPickerViewDelegate>
@property (nonatomic, strong) NSMutableArray *bezierPathArray;
@property (nonatomic,strong) AWSPaintSelectColorPickerView  *selectColorView;

@property (nonatomic,strong) UIButton  *btnSelectColor1;
@property (nonatomic,strong) UIButton  *btnSelectColor2;

@property (nonatomic,strong) AWSPaintSelectColorEasyView  *selectColorEasyView;
@end

@implementation AWSPaintView {
    UIView *headView;
    UIView *bottomView;
}

-(AWSPaintSelectColorPickerView *)selectColorView{
    if(!_selectColorView){
        _selectColorView = [[AWSPaintSelectColorPickerView alloc] init];
        _selectColorView.delegate = self;
        [self addSubview:_selectColorView];
    }
    return  _selectColorView;
}

-(AWSPaintSelectColorEasyView *)selectColorEasyView{
    if(!_selectColorEasyView){
        _selectColorEasyView = [[AWSPaintSelectColorEasyView alloc] init];
        _selectColorEasyView.delegate = self;
        [self addSubview:_selectColorEasyView];
    }
    return  _selectColorEasyView;
}

-(NSMutableArray *)bezierPathArray{
    if(!_bezierPathArray) {
        _bezierPathArray = [NSMutableArray array];
    }
    return  _bezierPathArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.lineColor = [UIColor redColor];
        
        [self addHeadBar];
        [self addBottomBar];
    }
    return self;
}

-(void)addHeadBar{
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    [self addSubview:headView];
    
    
    self.btnSelectColor1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, headView.bounds.size.width/2-1, 44)];
    [self.btnSelectColor1 setTitle:@"选色方案1" forState:UIControlStateNormal];
    [self.btnSelectColor1 addTarget:self action:@selector(selectColor1) forControlEvents:UIControlEventTouchUpInside];
    self.btnSelectColor1.backgroundColor = [UIColor orangeColor];
    [headView addSubview:self.btnSelectColor1];
    
    self.btnSelectColor2 = [[UIButton alloc] initWithFrame:CGRectMake(headView.bounds.size.width/2, 0, headView.bounds.size.width/2, 44)];
    [self.btnSelectColor2 setTitle:@"选色方案2" forState:UIControlStateNormal];
    [self.btnSelectColor2 addTarget:self action:@selector(selectColor2) forControlEvents:UIControlEventTouchUpInside];
    self.btnSelectColor2.backgroundColor = [UIColor orangeColor];
    [headView addSubview:self.btnSelectColor2];
    
    
}

-(void)addBottomBar{
    
    //添加操作栏，偷懒就不封装了
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-49, self.bounds.size.width, 49)];
    bottomView.backgroundColor = [UIColor blackColor];
    [self addSubview:bottomView];
    
    CGFloat btnW = self.bounds.size.width/4;
    UIButton *btnPreviewAction = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnW, bottomView.bounds.size.height)];
    [btnPreviewAction setTitle:@"撤销" forState:UIControlStateNormal];
    [btnPreviewAction addTarget:self action:@selector(btnPreviewActionClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnPreviewAction];
    
    UIButton *btnCleanAll = [[UIButton alloc] initWithFrame:CGRectMake(btnW, 0, btnW, bottomView.bounds.size.height)];
    [btnCleanAll setTitle:@"清空" forState:UIControlStateNormal];
    [btnCleanAll addTarget:self action:@selector(btnCleanAllClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnCleanAll];
    
    UIButton *btnXPC = [[UIButton alloc] initWithFrame:CGRectMake(btnW*2, 0, btnW, bottomView.bounds.size.height)];
    [btnXPC setTitle:@"橡皮擦" forState:UIControlStateNormal];
    [btnXPC addTarget:self action:@selector(btnXPCClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnXPC];
    
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(btnW *3, 0, btnW, bottomView.bounds.size.height)];
    [btnSave setTitle:@"保存" forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(btnSaveClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnSave];
    
}

#pragma mark - 选色方案
- (void)selectColor1 {
    self.selectColorView.hidden = NO;
    self.selectColorView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
    [UIView animateWithDuration:0.3 animations:^{
        self.selectColorView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
    }];
    
}

- (void)selectColor2 {
    self.selectColorEasyView.hidden = NO;
    self.selectColorEasyView.frame = CGRectMake(0, 0, 0, 44);
    [UIView animateWithDuration:0.3 animations:^{
        self.selectColorEasyView.frame = CGRectMake(0, 0, self.bounds.size.width, 44);
    }];
}


#pragma mark - 操作栏方法
- (void)btnPreviewActionClick {
    if(self.bezierPathArray.count>0){
        [self.bezierPathArray removeObjectAtIndex:self.bezierPathArray.count-1];
        [self setNeedsDisplay];
    }
}

- (void)btnCleanAllClick {
    [self.bezierPathArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void)btnXPCClick {
    self.isErase = YES;
}


- (void)btnSaveClick {
    //如果打开了选色1，先关闭
    if (!self.selectColorView.hidden) {
        self.selectColorView.hidden = YES;
    }
    [self showHeadAndBottom:NO];
    
    UIImage *currentImg = [self captureImageFromView:self];
    UIImageWriteToSavedPhotosAlbum(currentImg, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
    
    [self showHeadAndBottom:YES];
}

-(void)showHeadAndBottom:(BOOL)isShow{
    headView.hidden = !isShow;
    bottomView.hidden = !isShow;
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"保存失败";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
}

-(UIImage *)captureImageFromView:(UIView *)view
{
    CGRect screenRect = view.bounds;////CGRectMake(0, 108, KScreenWidth, KScreenHeight - 108 - 49);
    
    UIGraphicsBeginImageContext(screenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}



#pragma mark - 画画
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    self.bezierPath = [[AWSPaintBezierPath alloc] init];
    self.bezierPath.lineColor = self.lineColor;
    self.bezierPath.isErase = self.isErase;
    [self.bezierPath moveToPoint:currentPoint];
    
    [self.bezierPathArray addObject:self.bezierPath];
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    CGPoint previousPoint = [touch previousLocationInView:self];
    CGPoint midP = midpoint(previousPoint,currentPoint);
    //  这样写不会有尖头
    [self.bezierPath addQuadCurveToPoint:currentPoint controlPoint:midP];
    [self setNeedsDisplay];
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint previousPoint = [touch previousLocationInView:self];
    CGPoint midP = midpoint(previousPoint,currentPoint);
    [self.bezierPath addQuadCurveToPoint:currentPoint   controlPoint:midP];
    // touchesMoved
    [self setNeedsDisplay];
    
}

-(void)drawRect:(CGRect)rect{
    
    if (self.bezierPathArray.count) {
        for (AWSPaintBezierPath *path in self.bezierPathArray) {
            if (path.isErase) {
                
                [self.backgroundColor setStroke];
                
            }else{
                [path.lineColor setStroke];
            }
            
            
            path.lineCapStyle = kCGLineCapRound;
            path.lineJoinStyle = kCGLineCapRound;
            if (path.isErase) {
                path.lineWidth = 10;    //   这里可抽取出来枚举定义
                [path strokeWithBlendMode:kCGBlendModeDestinationIn alpha:1.0];
            }else{
                path.lineWidth = 3;
                [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
            }
            [path stroke];
            
        }
        
    }
    
    
    [super drawRect:rect];
}

static CGPoint midpoint(CGPoint p0, CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}




#pragma mark - 选色代理
-(void)getCurrentColor:(UIColor *)color{
    self.isErase = NO;
    self.lineColor = color;
}

-(void)selectColorEasyViewDidSelectColor:(UIColor *)color{
    self.isErase = NO;
    self.lineColor = color;
}

@end
