//
//  AWSPaintBezierPath.h
//  AwesomeiOS
//
//  Created by txooo on 2018/9/30.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWSPaintBezierPath : UIBezierPath

@property (nonatomic, strong) UIColor *lineColor;
//是否是橡皮擦
@property (nonatomic, assign) BOOL isErase;

@end

NS_ASSUME_NONNULL_END
