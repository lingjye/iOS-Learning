//
//  AWSPaintSelectColorPickerViewDelegate.h
//  AwesomeiOS
//
//  Created by txooo on 2018/9/30.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AWSPaintSelectColorPickerViewDelegate <NSObject>

- (void)getCurrentColor:(UIColor *)color;

@end

@interface AWSPaintSelectColorPickerView : UIView

@property (nonatomic, weak) id<AWSPaintSelectColorPickerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
