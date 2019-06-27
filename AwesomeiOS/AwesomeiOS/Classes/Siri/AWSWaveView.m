//
//  AWSWaveView.m
//  AwesomeiOS
//
//  Created by txooo on 2018/9/17.
//  Copyright © 2018年 领琾. All rights reserved.
//  https://github.com/raffael/SISinusWaveView

#import "AWSWaveView.h"

@interface AWSWaveView ()
//当前相
@property (nonatomic, assign) CGFloat phase;
@property (nonatomic, assign) CGFloat amplitude;

@end

@implementation AWSWaveView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _waveColor = [UIColor whiteColor];
        _numberOfWaves = 5;
        _primaryWaveLineWidth = 3;
        _secondaryWaveLineWidth = 1;
        _amplitude = 0.01;
        _frequency = 1.5;
        _idleAmplitude = 0.01;
        _density = 5;
        _phaseShift = -0.15;
    }
    return self;
}

- (void)updateWavePhase:(CGFloat)wavePhase {
    _phase += self.phaseShift;
    self.amplitude = fmax(wavePhase, self.idleAmplitude);
    //刷新
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    //清除绘制能容
    CGContextClearRect(context, rect);
//    [self.backgroundColor set];
//    CGContextFillRect(context, rect);
    
    //绘制波纹
    CGFloat midHeight = CGRectGetHeight(rect) / 2.0 - 64;
    CGFloat width = CGRectGetWidth(rect);
    CGFloat midWidth = width / 2.0;
    
    for (int i = 0; i < _numberOfWaves; i++) {
        CGFloat strokeLineWidth = i == 0 ? _primaryWaveLineWidth : _secondaryWaveLineWidth;
        CGFloat maxAmplitedu = midHeight - strokeLineWidth * 2;
        CGFloat progress = 1.0 - (CGFloat)i / _numberOfWaves;
        //赋范振幅
        CGFloat normedAmplitude = (1.5 * progress - 2.0 / _numberOfWaves) * _amplitude;
        CGFloat multiplier = MIN(1.0, progress / 3.0 * 2.0);
        //线条层次感
        [[_waveColor colorWithAlphaComponent:multiplier * CGColorGetAlpha(_waveColor.CGColor)] set];
        
        //设置线条宽度
        CGContextSetLineWidth(context, strokeLineWidth);
        
        for (CGFloat x = 0; x < (width + _density); x += _density) {
            CGFloat scaling = -pow(1 / midWidth * (x - midWidth), 2) + 1;
            CGFloat y = scaling * maxAmplitedu * normedAmplitude * sinf(2 * M_PI * (x / width) * _frequency + _phase) + midHeight;
            
            if (x == 0) {
                CGContextMoveToPoint(context, x, y);
            } else {
                CGContextAddLineToPoint(context, x, y);
            }
        }
        CGContextStrokePath(context);
    }
}

@end
