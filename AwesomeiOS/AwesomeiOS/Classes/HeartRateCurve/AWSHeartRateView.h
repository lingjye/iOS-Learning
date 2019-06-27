//
//  AWSHeartRateView.h
//  AwesomeiOS
//
//  Created by txooo on 2018/9/12.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWSPointManager : NSObject
@property (nonatomic, assign, readonly) NSInteger numberOfRefreshElements;
@property (nonatomic, assign, readonly) NSInteger numberOfTanslationElements;
@property (nonatomic, assign, readonly) CGPoint *refreshPointInstance;
@property (nonatomic, assign, readonly) CGPoint *translationPointInstance;

- (void)addPointAsRefreshChangeForm:(CGPoint)point;
- (void)addPointASTranslationChangeForm:(CGPoint)point;

@end

@interface AWSHeartRateView : UIView

- (void)animationWithPoints:(CGPoint *)points pointsCount:(NSInteger)count;

@end
