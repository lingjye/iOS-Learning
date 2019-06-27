//
//  TRIGLView.m
//  HelloTriangle
//
//  Created by 领琾 on 2019/6/25.
//  Copyright © 2019 领琾. All rights reserved.
//

#import "TRIGLView.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/gltypes.h>
#import "TRIGLESUtils.h"

@interface TRIGLView () {
    CAEAGLLayer *_eaglLayer;
    EAGLContext *_context;
    GLuint _colorFrameBuffer;
    GLuint _colorRenderBufffer;
    GLuint _program;
    GLuint _position;
    GLuint _colorSlot;
}
@end

@implementation TRIGLView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setlayer];
        [self setContext];
        [self destoryBuffer];
        [self setRenderBuffer];
        [self setFrameBuffer];
        [self setupProgram];
        [self render];
    }
    return self;
}

// 设置 layer class
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)setlayer {
    CAEAGLLayer *layer = (CAEAGLLayer *) self.layer;
    // 设置不透明
    layer.opaque = YES;
    
    //     设置描绘属性， 这里设置不维持渲染内容以及颜色格式为 RGBA8
    layer.drawableProperties = @{ kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8 ,
                                  kEAGLDrawablePropertyRetainedBacking : @NO };
    
    _eaglLayer = layer;
}

- (void)setContext {
    // 设置上下文 使用 es3 版本 管理所有使用OpenGL ES 进行描绘的状态，命令以及资源信息
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!_context) {
        NSLog(@"Faild to initialze OpenGLES");
        return;
    }
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        return;
    }
}

// 由于 layer 的宽高变化，导致原来创建的 renderbuffer不再相符，我们需要销毁既有 renderbuffer 和 framebuffe
- (void)destoryBuffer {
    glDeleteFramebuffers(1, &_colorFrameBuffer);
    _colorFrameBuffer = 0;
    glDeleteRenderbuffers(1, &_colorRenderBufffer);
    _colorRenderBufffer = 0;
}

- (void)setRenderBuffer {
    GLuint buffer = 0;
    glGenRenderbuffers(1, &buffer);
    _colorRenderBufffer = buffer;
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBufffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setFrameBuffer {
    GLuint buffer = 0;
    glGenFramebuffers(1, &buffer);
    _colorFrameBuffer = buffer;
    glBindFramebuffer(GL_FRAMEBUFFER, _colorFrameBuffer);
    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBufffer);
}

- (void)setupProgram {
    // 编译着色器
    _program = [TRIGLESUtils loadProgramWithverShaderFileName:@"triangle_shaderv.glsl" fragShaderFileName:@"triangle_shaderf.glsl"];
    if (!_program) {
        return;
    }
    glUseProgram(_program);
    
    _position = glGetAttribLocation(_program, "vPosition");
    _colorSlot = glGetAttribLocation(_program, "a_Color");
}

- (void)render {
    // 绘制
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, (GLsizei)(self.frame.size.width), (GLsizei)self.frame.size.height);
    
    // 三角形坐标顶点 依次为 上， 左， 右 三个顶点坐标， 坐标系从屏幕中心开始
    // 2D 屏幕中心坐标 O(0, 0, 0), 左上角 (-1, 1, 0), 右上角 (1, 1, 0), 左下角 (-1, -1, 0), 右下角 (1, -1, 0)
    GLfloat vertices[] = {
        0, 0.5, 0,
        -0.5, -0.5, 0,
        0.5, -0.5, 0
    };
    
    // 上， 左， 右三个顶点对应颜色 (r, g, b, a)， 渐变填充
    GLfloat colors[] = {
        1, 0, 0, 1,
        0, 1, 0, 1,
        0, 0, 1, 1
    };
    
    // 加载顶点数据
    glVertexAttribPointer(_position, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_position);
    
    // 加载颜色数据
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, 0, colors);
    glEnableVertexAttribArray(_colorSlot);
    
    // 绘制
    glDrawArrays(GL_TRIANGLES, 0, 3);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
}


@end
