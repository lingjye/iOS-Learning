/* 
  Triangle.strings
  HelloTriangle

  Created by 领琾 on 2019/6/25.
  Copyright © 2019 领琾. All rights reserved.
*/

// Example 1 顶点着色器

//uniform mat4 uMVPMatrix;                             // 应用程序传入顶点着色器的总变换矩阵
//attribute vec4 aPosition;                            // 应用程序传入顶点着色器的顶点位置
//attribute vec2 aTextureCoord;                        // 应用程序传入顶点着色器的顶点纹理坐标
//attribute vec4 aColor                                // 应用程序传入顶点着色器的顶点颜色变量
//varying vec4 vColor                                  // 用于传递给片元着色器的顶点颜色数据
//varying vec2 vTextureCoord;                          // 用于传递给片元着色器的顶点纹理数据
//void main()
//{
//    gl_Position = uMVPMatrix * aPosition;            // 根据总变换矩阵计算此次绘制此顶点位置
//    vColor = aColor;                                 // 将顶点颜色数据传入片元着色器
//    vTextureCoord = aTextureCoord;                   // 将接收的纹理坐标传递给片元着色器
//}

// Example 2 片段着色器

//precision mediump float;                           // 设置工作精度
//varying vec4 vColor;                               // 接收从顶点着色器过来的顶点颜色数据
//varying vec2 vTextureCoord;                        // 接收从顶点着色器过来的纹理坐标
//uniform sampler2D sTexture;                        // 纹理采样器，代表一幅纹理
//void main()
//{
//    gl_FragColor = texture2D(sTexture, vTextureCoord) * vColor;// 进行纹理采样
//}


