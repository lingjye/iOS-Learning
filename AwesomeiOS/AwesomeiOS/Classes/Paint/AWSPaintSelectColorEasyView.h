//
//  AWSPaintSelectColorEasyViewDelegate.h
//  AwesomeiOS
//
//  Created by txooo on 2018/9/30.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AWSPaintSelectColorEasyViewDelegate <NSObject>

- (void)selectColorEasyViewDidSelectColor:(UIColor *)color;

@end

@interface AWSPaintSelectColorEasyView : UIView

@property (nonatomic, weak) id<AWSPaintSelectColorEasyViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
