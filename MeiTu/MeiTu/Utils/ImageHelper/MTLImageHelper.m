//
//  MTLImageHelper.m
//  MeiTu
//
//  Created by txooo on 2019/4/3.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MTLImageHelper.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation MTLImageHelper

+ (UIImage *)imageFromView:(UIView *)theView {
    // Draw a view's contents into an image context
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef contex = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:contex];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageFromView:(UIView *)theView saveToPhoto:(BOOL)saveToPhoto {
    // Draw a view's contents into an image context
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef contex = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:contex];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (saveToPhoto) {
        UIImageWriteToSavedPhotosAlbum(image, [self class], @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    return image;
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (error){
        NSLog(@"%@", error.localizedDescription);
    }else {
        // 保存成功
    }
}


// 将gif图片解析成image数组
+ (NSMutableArray *)parseGIFDataToImageArray:(NSData *)data {
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    CGImageSourceRef srcRef = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if (srcRef) {
        size_t l = CGImageSourceGetCount(srcRef);
        frames = [NSMutableArray arrayWithCapacity:l];
        for (size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(srcRef, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(srcRef, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [frames addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
        CFRelease(srcRef);
    }
    return frames;
}

+(void)animationRotateAndScaleEffects:(UIView *)view
{
    [UIView animateWithDuration:0.35f animations:^{
/**
*  @see http://donbe.blog.163.com/blog/static/138048021201061054243442/
*
*  @param  transform 形变属性(结构体),可以利用这个属性去对view做一些翻转或者缩放.详解请猛戳↑URL.
*
*  @method valueWithCATransform3D: 此方法需要一个CATransform3D的结构体.一些非详细的讲解可以看下面的URL
*
*  @see http://blog.csdn.net/liubo0_0/article/details/7452166
*
*/
        view.transform = CGAffineTransformMakeScale(0.001, 0.001);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
// 向右旋转45°缩小到最小,然后再从小到大推出.
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.70, 0.40, 0.80)];
/**
*  其他效果:
*  从底部向上收缩一半后弹出
*  animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0)];
*
*  从底部向上完全收缩后弹出
*  animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1.0, 0.0, 0.0)];
*
*  左旋转45°缩小到最小,然后再从小到大推出.
*  animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.50, -0.50, 0.50)];
*
*  旋转180°缩小到最小,然后再从小到大推出.
*  animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.1, 0.2, 0.2)];
*/
    
        animation.duration = 0.45;
        animation.repeatCount = 1;
        [view.layer addAnimation:animation forKey:nil];
    
    }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.35f animations:^
                          {
                              view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                          }];
                     }];
}


@end
