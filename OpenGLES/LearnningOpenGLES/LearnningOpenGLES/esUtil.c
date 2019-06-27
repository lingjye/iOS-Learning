//
//  esUtil.c
//  HelloTriangle
//
//  Created by 领琾 on 2019/6/24.
//  Copyright © 2019 领琾. All rights reserved.
//

#include "esUtil.h"
#include <OpenGLES/gltypes.h>
#include <OpenGLES/ES3/glext.h>
#include <stdlib.h>
#if 0
typedef struct {
    // handle to a program project
    GLuint programObject;
} UserData;

/*
 create a shader object, load the shader source , and compile the shader
 */

GLuint LoadShader(GLenum type, const char *shaderSrc) {
    GLuint shader;
    GLint compiled;

    //create the shader object
    shader = glCreateShader(type);
    if (shader == 0) {
        return 0;
    }

    // load the shader source
    glShaderSource(shader, 1, &shaderSrc, NULL);

    // compile the shader
    glCompileShader(shader);

    // check the compile status
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if (!compiled) {
        GLint infoLen = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            char *infoLog = malloc(sizeof(char) * infoLen);
            glGetShaderInfoLog(shader, infoLen, NULL, infoLog);
//            esLo
            printf("error compiling shader:\n%s\n", infoLog);
            free(infoLog);
        }
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}

/*
 initialize the shader and progranm object
 */
int Init( EAGLContext *esContext) {
    UserData *userData = esContext -> userData;
    char vShaderStr[] =
    "#version 300 es \n"
    "layout(location=0) in vec4 vPosition; \n"
    "void main() \n"
    "{ \n"
    "   gl_Position = vPosition; \n"
    "} \n";
    
    char fShaderStr[] =
    "#version 300 es \n"
    "precision mediump float; \n"
    "out vec4 fragColor;"
    "void main() \n"
    "{ \n"
    "   fragColor = vec4(1.0, 0.0, 0.0, 1.0); \n"
    "} \n";
    
    GLuint vertexShader;
    GLuint fragmentShader;
    GLuint programObject;
    GLint linked;
    
    // Load the vertex/fragment shaders
    vertexShader = LoadShader(GL_VERTEX_SHADER, vShaderStr);
    fragmentShader = LoadShader(GL_VERTEX_SHADER, fShaderStr);
    
    // create the programobject
    programObject = glCreateProgram();
    if (programObject == 0) {
        return 0;
    }
    
    glAttachShader(programObject, vertexShader);
    glAttachShader(programObject, fragmentShader);
    
    // link the program
    glLinkProgram(programObject);
    
    // check the link status
    glGetProgramiv(programObject, GL_LINK_STATUS, &linked);
    
    if (!linked) {
        GLint infoLen = 0;
        glGetProgramiv(programObject, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            char *infoLog = malloc(sizeof(char) * infoLen);
            glGetProgramInfoLog(programObject, infoLen, NULL, infoLog);
            
            printf("Error linking program: \n%s\n", infoLog);
            free(infoLog);
        }
        glDeleteProgram(programObject);
        return 0;
    }
    
    // Store the program object
    userData -> programObject = programObject;
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    
    return 1;
    
}

// draw a triangle using the shader pair created in Init()
void Draw(ESContext *esContext) {
    UserData *userData = esContext -> userData;
    GLfloat vVertices[] = {
        0.0f, 0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f
    };
    
    // set the viewport
    glViewport(0, 0, esContext -> width, esContext -> height);
    
    // clear the color buffer
    glClear(GL_COLOR_BUFFER_BIT);
    
    // user the program object
    glUseProgram(userData -> programObject);
    
    // load the vertex data
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, vVertices);
    
    glEnableVertexAttribArray(0);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
}

void Shutdown (ESContext *esContext) {
    UserData *userData = esContext -> userData;
    glDeleteProgram(userData -> programObject);
}

int esMain(ESContext *esContext) {
    esContext -> userData = malloc(sizeof(UserData));
    esCreateWindow (esContext, "Hello Trianle", 320, 240, ES_WINDOW_RGB);
    if (!Init(esContext)) {
        return GL_FALSE;
    }
    esRegisterShutdownFunc(esContext, Shutdown);
    esRegisterDrawFunc(esContext, Draw);
    return GL_TRUE;
}
#endif
