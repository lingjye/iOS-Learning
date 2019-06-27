//
//  TRIGLESUtils.m
//  HelloTriangle
//
//  Created by 领琾 on 2019/6/25.
//  Copyright © 2019 领琾. All rights reserved.
//

#import "TRIGLESUtils.h"
#include <stdlib.h>

@implementation TRIGLESUtils

+ (GLuint)loadShaderFileWithType:(GLenum)type fileName:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    if (!path) {
        NSLog(@"File does not exist!");
        return 0;
    }
    NSString *shaderString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return [TRIGLESUtils loadShaderStringWithType:type shaderString:shaderString];
}

+ (GLuint)loadShaderStringWithType:(GLenum)type shaderString:(NSString *)shaderString {
    // 创建 着色器对象
    GLuint shaderHandle = glCreateShader(type);
    GLint shaderStringLength = (GLint)(int)(shaderString.length);
    const char *shaderCString = [shaderString cStringUsingEncoding:NSUTF8StringEncoding];
    /* 把着色器源码附加到着色器对象上
     glShaderSource(shader: GLuint, count: GLsizei, String: UnsafePointer<UnsafePointer<GLchar>?>!, length: UnsafePointer<GLint>!)
     shader： 着色器对象
     count：指定要传递的源码字符串数量，这里只有一个
     String：着色器源码
     length：源码长度
     */
    glShaderSource(shaderHandle, (GLsizei)1, &shaderCString, &shaderStringLength);
    // 编译着色器
    glCompileShader(shaderHandle);
    
    // 编译是否成功的状态 GL_FALSE GL_TRUE
    GLint compileStatus = 0;
    
    // 获取编译状态
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileStatus);
    
    if (compileStatus == GL_FALSE) {
        GLsizei infoLength = 0;
        glGetShaderiv(shaderHandle, GL_INFO_LOG_LENGTH, &infoLength);
        GLsizei actualLength = 0;

        char *infoLog = malloc(sizeof(char) * infoLength);
        glGetShaderInfoLog(shaderHandle, infoLength, &actualLength, infoLog);
        NSLog(@"%@", [NSString stringWithCString:infoLog encoding:NSUTF8StringEncoding]);
        free(infoLog);
        return 0;
    }
    return shaderHandle;
}

+ (GLuint)loadProgramWithverShaderFileName:(NSString *)verShaderFileName fragShaderFileName:(NSString *)fragShaderFileName {
    
    GLuint vertextShader = [TRIGLESUtils loadShaderFileWithType:GL_VERTEX_SHADER fileName:verShaderFileName];
    if (vertextShader == 0) {
        return 0;
    }
    GLuint fragmentShader = [TRIGLESUtils loadShaderFileWithType:GL_FRAGMENT_SHADER fileName:fragShaderFileName];
    if (fragmentShader == 0) {
        glDeleteShader(vertextShader);
        return 0;
    }
    
    // 创建着色器程序对象
    GLuint programHandel = glCreateProgram();
    
    if (programHandel == 0) return 0;
    
    // 将着色器附加到程序上
    glAttachShader(programHandel, vertextShader);
    glAttachShader(programHandel, fragmentShader);
    
    // 链接着色器程序
    glLinkProgram(programHandel);
    
    // 获取链接状态
    GLint linkStatus = 0;
    glGetProgramiv(programHandel, GL_LINK_STATUS, &linkStatus);
    if (linkStatus == GL_FALSE) {
        GLsizei infoLength = 0;
        glGetProgramiv(programHandel, GL_INFO_LOG_LENGTH, &infoLength);
        GLsizei actualLength = 0;

        char *infoLog = malloc(sizeof(char) * infoLength);
        glGetProgramInfoLog(programHandel, infoLength, &actualLength, infoLog);
        NSLog(@"%@", [NSString stringWithCString:infoLog encoding:NSUTF8StringEncoding]);
        free(infoLog);
        return 0;
    }
    
    // 释放资源
    glDeleteShader(vertextShader);
    glDeleteShader(fragmentShader);
    
    return programHandel;
}

@end
