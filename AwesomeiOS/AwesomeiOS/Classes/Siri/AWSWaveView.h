//
//  AWSWaveView.h
//  AwesomeiOS
//
//  Created by txooo on 2018/9/17.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AWSWaveView : UIView

/**
 波纹条数, 默认5
 */
@property (nonatomic, assign) NSInteger numberOfWaves;

/**
 波纹颜色, 默认白色
 */
@property (nonatomic, strong) UIColor *waveColor;

/**
 主波纹宽度, 默认3
 */
@property (nonatomic, assign) CGFloat primaryWaveLineWidth;

/**
 副波纹宽度, 默认1
 */
@property (nonatomic, assign) CGFloat secondaryWaveLineWidth;

/**
 当前振幅
 */
@property (nonatomic, assign, readonly) CGFloat amplitude;

/**
 频率, 默认1.5
 */
@property (nonatomic, assign) CGFloat frequency;

/**
 正常状态时的最小振幅, 默认0.01, 通常接近0
 */
@property (nonatomic, assign) CGFloat idleAmplitude;

/**
 密度, 默认5
 */
@property (nonatomic, assign) CGFloat density;

/**
 移相,相移(物理学名称), 默认-0.15
 */
@property (nonatomic, assign) CGFloat phaseShift;

/**
 更新波纹方法

 @param wavePhase 当前的值
 */
- (void)updateWavePhase:(CGFloat)wavePhase;

@end
