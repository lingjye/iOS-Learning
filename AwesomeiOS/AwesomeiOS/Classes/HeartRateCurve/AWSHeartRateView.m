//
//  AWSHeartRateView.m
//  AwesomeiOS
//
//  Created by txooo on 2018/9/12.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import "AWSHeartRateView.h"

static const NSInteger kMaxContainerCapacity = 300;

@interface AWSPointManager ()
@property (nonatomic, assign) NSInteger numberOfRefreshElements;
@property (nonatomic, assign) NSInteger numberOfTanslationElements;
@property (nonatomic, assign) CGPoint *refreshPointInstance;
@property (nonatomic, assign) CGPoint *translationPointInstance;
@end

@implementation AWSPointManager

- (void)dealloc {
    free(_refreshPointInstance);
    free(_translationPointInstance);
    _refreshPointInstance = _refreshPointInstance = NULL;
}

static NSInteger refreshPointCount = 0;
static NSInteger translationPointCount = 0;

- (instancetype)init {
    if (self = [super init]) {
        refreshPointCount = 0;
        translationPointCount = 0;
        self.refreshPointInstance = malloc(sizeof(CGPoint) * kMaxContainerCapacity);
        memset(self.refreshPointInstance, 0, sizeof(CGPoint) * kMaxContainerCapacity);
        
        self.translationPointInstance = malloc(sizeof(CGPoint) * kMaxContainerCapacity);
        memset(self.translationPointInstance, 0, sizeof(CGPoint) * kMaxContainerCapacity);
    }
    return self;
}

- (void)addPointAsRefreshChangeForm:(CGPoint)point {
    if (refreshPointCount < kMaxContainerCapacity) {
        self.numberOfRefreshElements = refreshPointCount + 1;
        self.refreshPointInstance[refreshPointCount] = point;
        refreshPointCount++;
    }else {
        NSInteger workIndex = 0;
        while (workIndex < kMaxContainerCapacity) {
            self.refreshPointInstance[workIndex] = self.refreshPointInstance[workIndex + 1];
            workIndex++;
        }
        self.refreshPointInstance[kMaxContainerCapacity - 1] = point;
        self.numberOfRefreshElements = kMaxContainerCapacity;
    }
//    printf("当前元素个数:%2ld->",(long)self.numberOfRefreshElements);
//    for (int k = 0; k < kMaxContainerCapacity; ++k) {
//        printf("(%4.0f,%4.0f)",self.refreshPointInstance[k].x,self.refreshPointInstance[k].y);
//    }
//    putchar('\n');
}

- (void)addPointASTranslationChangeForm:(CGPoint)point {
    if (translationPointCount < kMaxContainerCapacity) {
        self.numberOfTanslationElements = translationPointCount + 1;
        self.translationPointInstance[translationPointCount] = point;
        translationPointCount++;
    }else {
        NSInteger workIndex = kMaxContainerCapacity - 1;
        while (workIndex > 0) {
            self.translationPointInstance[workIndex].y = self.translationPointInstance[workIndex - 1].y;
            workIndex--;
        }
        self.translationPointInstance[0].x = 0;
        self.translationPointInstance[0].y = point.y;
        self.numberOfTanslationElements = kMaxContainerCapacity;
    }
//    printf("当前元素个数:%2ld->",(long)self.numberOfTanslationElements);
//    for (int k = 0; k < self.numberOfTanslationElements; ++k) {
//        printf("(%.0f,%.0f)",self.translationPointInstance[k].x,self.translationPointInstance[k].y);
//    }
//    putchar('\n');
}

@end

@interface AWSHeartRateView ()

@property (nonatomic, assign) CGPoint *points;
@property (nonatomic, assign) NSInteger currentPointsCount;

@end

@implementation AWSHeartRateView

- (void)setPoints:(CGPoint *)points {
    _points = points;
    [self setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clearsContextBeforeDrawing = YES;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void)animationWithPoints:(CGPoint *)points pointsCount:(NSInteger)count {
    self.currentPointsCount = count;
    self.points = points;
}

- (void)drawRect:(CGRect)rect {
    [self drawGrid];
    [self drawCurve];
}

- (void)drawGrid {
    //获取上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat childGridWidth = 30;
    
    CGContextSetLineWidth(contextRef, 0.2);
    CGContextSetStrokeColorWithColor(contextRef, [UIColor redColor].CGColor);
    
    //纵向
    int pos_x = 1;
    while (pos_x < viewWidth) {
        CGContextMoveToPoint(contextRef, pos_x, 1);
        CGContextAddLineToPoint(contextRef, pos_x, viewHeight);
        CGContextStrokePath(contextRef);
        
        pos_x += childGridWidth;
    }
    
    //横向
    CGFloat pos_y = 1;
    while (pos_y <= viewHeight) {
        CGContextMoveToPoint(contextRef, 1, pos_y);
        CGContextAddLineToPoint(contextRef, viewWidth, pos_y);
        CGContextStrokePath(contextRef);
        
        pos_y += childGridWidth;
    }
    
    //小方格
    CGContextSetLineWidth(contextRef, 0.1);
    
    childGridWidth = childGridWidth/5;
    
    pos_x = 1 + childGridWidth;
    while (pos_x < viewWidth) {
        CGContextMoveToPoint(contextRef, pos_x, 1);
        CGContextAddLineToPoint(contextRef, pos_x, viewHeight);
        CGContextStrokePath(contextRef);
        
        pos_x += childGridWidth;
    }
    
    pos_y = 1 + childGridWidth;
    while (pos_y < viewHeight) {
        CGContextMoveToPoint(contextRef, 1, pos_y);
        CGContextAddLineToPoint(contextRef, viewWidth, pos_y);
        CGContextStrokePath(contextRef);
        
        pos_y += childGridWidth;
    }
}

- (void)drawCurve {
    if (self.currentPointsCount == 0) {
        return;
    }
    
    CGFloat lineWidth = 0.8;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextRef, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(contextRef, lineWidth);
  
    CGContextMoveToPoint(contextRef, self.points[0].x, self.points[0].y);
//    NSLog(@"---%@",[NSValue valueWithPointer:self.points]);
    for (int i = 1; i< self.currentPointsCount; ++i) {
        if (self.points[i - 1].x < self.points[i].x) {
            CGContextAddLineToPoint(contextRef, self.points[i].x, self.points[i].y);
        }else {
            CGContextMoveToPoint(contextRef, self.points[i].x, self.points[i].y);
        }
    }
    CGContextStrokePath(contextRef);
}

@end
