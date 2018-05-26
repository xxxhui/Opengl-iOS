//
//  GLUtils.m
//  Opengl-iOS
//
//  Created by xxxhui on 2018/5/23.
//  Copyright © 2018年 No Name. All rights reserved.
//

#import "GLUtils.h"
@interface GLUtils()
+ (GLuint)loadShader:(NSString*)shaderName withType:(GLenum)shaderType;
@end

@implementation GLUtils
+ (GLuint)loadShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    //根据文件名找到资源路径，读取成字符串，比Android方便
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if(!shaderString) {
        return -1;
    }
    
    GLuint shader;
    GLint compiled;
    
    shader = glCreateShader(shaderType);
    if(shader == 0) {
        return -2;
    }
    
    const char* shaderSrc = [shaderString UTF8String];
    int shaderSrcLenth = (int)[shaderString length];
    //加载shader源码
    glShaderSource(shader, 1, &shaderSrc, &shaderSrcLenth);
    //编译shader
    glCompileShader(shader);
    //检查是否编译出错
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if(!compiled) {
        //如果出错，打印错误信息
        GLint infoLen = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
        if(infoLen > 1) {
            GLchar infoLog[infoLen];
            glGetShaderInfoLog(shader, infoLen, nil, &infoLog[0]);
            NSString* msg = [NSString stringWithUTF8String:infoLog];
            NSLog(@"%@", msg);
        }
        //释放资源
        glDeleteShader(shader);
        return 0;
    }
   
    return shader;
}

+ (GLuint)createProgramWithVertexShader:(NSString *)vertexShaderName fragmentShader:(NSString *)fragmentShaderName {
    
    GLuint vertexShader;
    GLuint fragmentShader;
    GLuint programObject;
    
    //加载shader
    vertexShader = [self loadShader:vertexShaderName withType:GL_VERTEX_SHADER];
    fragmentShader = [self loadShader:fragmentShaderName withType:GL_FRAGMENT_SHADER];
    
    programObject = glCreateProgram();
    
    if(!programObject) {
        return 0;
    }
    //给program绑定shader
    glAttachShader(programObject, vertexShader);
    glAttachShader(programObject, fragmentShader);
    //链接program
    glLinkProgram(programObject);
    //检查链接是否成功
    GLint linked;
    glGetProgramiv(programObject, GL_LINK_STATUS, &linked);
    if(!linked) {
        GLint infoLen = 0;
        glGetProgramiv(programObject, GL_INFO_LOG_LENGTH, &infoLen);
        if(infoLen > 1) {
            GLchar infoLog[infoLen];
            glGetProgramInfoLog(programObject, infoLen, 0, &infoLog[0]);
            NSString* msg = [NSString stringWithUTF8String:infoLog];
            NSLog(@"%@", msg);
        }
        return 0;
    }
    return programObject;
}
@end
