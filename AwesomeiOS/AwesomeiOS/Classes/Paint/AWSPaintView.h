//
//  AWSPaintView.h
//  AwesomeiOS
//
//  Created by txooo on 2018/9/18.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWSPaintBezierPath.h"

@interface AWSPaintView : UIView

@property (nonatomic, strong) AWSPaintBezierPath *bezierPath;

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) BOOL isErase;

@end
