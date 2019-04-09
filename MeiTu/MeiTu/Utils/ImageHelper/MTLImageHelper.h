//
//  MTLImageHelper.h
//  MeiTu
//
//  Created by txooo on 2019/4/3.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLImageHelper : NSObject

// 截取屏幕上指定区域, 返回image对象
+ (UIImage *)imageFromView:(UIView *)theView;

+(void)animationRotateAndScaleEffects:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
