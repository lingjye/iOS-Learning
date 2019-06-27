//
//  GLView.m
//  HelloTriangle
//
//  Created by 领琾 on 2019/6/24.
//  Copyright © 2019 领琾. All rights reserved.
//

#import "GLView.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/gltypes.h>


@interface GLView () {
    CAEAGLLayer *_eaglLayer;
    EAGLContext *_context;
    GLuint _colorRenderBuffer;
}
@end

@implementation GLView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //        self.backgroundColor = [UIColor colorWithRed:0 green:104.0/255 blue:55.0/255 alpha:1];
        [self setupLayer];
        [self setupContenxt];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self render];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

// 设置layer class 为 CAEAGLLayer
//想要显示OpenGL的内容，你需要把它缺省的layer设置为一个特殊的layer。（CAEAGLLayer）。这里通过直接复写layerClass的方法。
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)setupLayer {
    // 设置 layer 不透明
    // 因为缺省的话，CALayer是透明的。而透明的层对性能负荷很大，特别是OpenGL的层。
    //（如果可能，尽量都把层设置为不透明。另一个比较明显的例子是自定义tableview cell）
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opaque = YES;
}

- (void)setupContenxt {
    // EAGLContext管理所有通过OpenGL进行draw的信息。这个与Core Graphics context类似。
    // 当你创建一个context，你要声明你要用哪个version的AP
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES3;
    _context = [[EAGLContext alloc] initWithAPI:api];
    
    if (!_context) {
        NSLog(@"Faild to initialze OpenGLES");
        return;
    }
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        return;
    }
}
/*
 Render buffer 是OpenGL的一个对象，用于存放渲染过的图像。
 
 　　有时候你会发现render buffer会作为一个color buffer被引用，因为本质上它就是存放用于显示的颜色。
 
 　　创建render buffer的三步：
 1.     调用glGenRenderbuffers来创建一个新的render buffer object。这里返回一个唯一的integer来标记render buffer（这里把这个唯一值赋值到_colorRenderBuffer）。有时候你会发现这个唯一值被用来作为程序内的一个OpenGL 的名称。（反正它唯一嘛）
 
 　2.     调用glBindRenderbuffer ，告诉这个OpenGL：我在后面引用GL_RENDERBUFFER的地方，其实是想用_colorRenderBuffer。其实就是告诉OpenGL，我们定义的buffer对象是属于哪一种OpenGL对象
 
 　　3.     最后，为render buffer分配空间。renderbufferStorage
 */
- (void)setupRenderBuffer {
    // 创建 render buffer （渲染缓冲区）
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
}

/*
 Frame buffer也是OpenGL的对象，它包含了前面提到的render buffer，以及其它后面会讲到的诸如：depth buffer、stencil buffer 和 accumulation buffer。
 
 　　前两步创建frame buffer的动作跟创建render buffer的动作很类似。（反正也是用一个glBind什么的）
 
 　　而最后一步  glFramebufferRenderbuffer 这个才有点新意。它让你把前面创建的buffer render依附在frame buffer的GL_COLOR_ATTACHMENT0位置上。
 */
- (void)setupFrameBuffer {
    // 创建一个frame buffer （帧缓冲区）
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
}

/*
 这里每个RGB色的范围是0~1，所以每个要除一下255.
 
 　　下面解析一下每一步动作：
 
 　　1.      调用glClearColor ，设置一个RGB颜色和透明度，接下来会用这个颜色涂满全屏。
 
 　　2.      调用glClear来进行这个“填色”的动作（大概就是photoshop那个油桶嘛）。还记得前面说过有很多buffer的话，这里我们要用到GL_COLOR_BUFFER_BIT来声明要清理哪一个缓冲区。
 
 　　3.      调用OpenGL context的presentRenderbuffer方法，把缓冲区（render buffer和color buffer）的颜色呈现到UIView上。
 */
- (void)render {
    glClearColor(0, 1, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

@end
