//
//  ViewController.m
//  OpenGL
//
//  Created by txooo on 2019/2/25.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "GLTViewController.h"

//顶点结构体
typedef struct {
    GLKVector4 positionCoords;
}sceneVertex;

//三角形的三个顶点 笛卡尔坐标系
static const sceneVertex vertices[] = {
    {{ -0.5f, -0.5f, 0.0 }},
    {{ 0.5f, -0.0, 0.0 }},
    {{ -0.5f, 0.5f, 0.0 }},
};

@interface GLTViewController ()

@property (nonatomic, strong) GLKBaseEffect *baseEffect;

//声明缓存ID属性
@property (nonatomic, assign) GLuint *vertextBufferID;

@end

@implementation GLTViewController

@synthesize vertextBufferID = vertextBufferID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    GLKView *view = (GLKView *)self.view;
    //创建sOpenGL ES2.0上下文
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    //设置当前上下文
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    //使用静态颜色绘制
    self.baseEffect.useConstantColor = GL_TRUE;
    //设置默认绘制颜色, 参数分别是RGBA
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    //设置背景色为黑色
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    //生成并绑定缓存数据
    glGenBuffers(1, &vertextBufferID);
    //绑定指定标志符的缓存为当前缓存
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.baseEffect prepareToDraw];
    
    //Clear Frame Buffer
    glClear(GL_COLOR_BUFFER_BIT);
    
    //开启缓存
    /*
     glEnableVertexAttribArray 开启对应的顶点缓存属性
     glVertexAttribPointer 设置指针从顶点数组中读取数据
     glDrawArrays 绘制图形
     */
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //设置缓存数据指针
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,//小数点固定数据是否被改变
                          sizeof(sceneVertex),
                          NULL);    //从开始位置
    //绘图
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

- (void)dealloc {
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    if (0 != vertextBufferID) {
        glDeleteBuffers(1, &vertextBufferID);
        vertextBufferID = 0;
    }
}

@end
