//
//  TRIGLESUtils.h
//  HelloTriangle
//
//  Created by 领琾 on 2019/6/25.
//  Copyright © 2019 领琾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/gltypes.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRIGLESUtils : NSObject

+ (GLuint)loadShaderFileWithType:(GLenum)type fileName:(NSString *)fileName;

+ (GLuint)loadShaderStringWithType:(GLenum)type shaderString:(NSString *)shaderString;

+ (GLuint)loadProgramWithverShaderFileName:(NSString *)verShaderFileName
                      fragShaderFileName:(NSString *)fragShaderFileName;


@end

NS_ASSUME_NONNULL_END
