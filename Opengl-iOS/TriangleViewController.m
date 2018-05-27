//
//  TriangleViewController.m
//  Opengl-iOS
//
//  画一个最简单的三角形。开启OpenGL的 Hello World !
//
//  Created by xxxhui on 2018/5/22.
//  Copyright © 2018年 No Name. All rights reserved.
//

#import "TriangleViewController.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "GLUtils.h"
#import <GLKit/GLKit.h>

@interface TriangleViewController () {
    EAGLContext* _eglContext;       // 绘制上下文
    CAEAGLLayer* _eglLayer;         // ios提供的绘制层
    GLuint _eglProgram;             // glProgrom的id
    GLuint _colorBufferRender;      // RBO，渲染颜色缓冲区，后面可能用到深度缓冲区
    GLuint _frameBuffer;            // FBO
    GLuint _vertexPos;              // 用于绑定shader中的Position参数
    GLuint _colorPos;               // 用于绑定shader中的SourceColor参数
    GLint _frameBufferWidth;        // 画布宽度
    GLint _frameBufferHeight;       // 画布高度
    //GLint _mvp;                   // 变换矩阵
}

@end

@implementation TriangleViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //stup1:设置context
    [self initEglContext];
    //stup2:设置display
    [self initEglDisplay];
    //stup3:绑定渲染缓存区
    //此处与Android略有不同，有一篇博客总结了这些，如下：https://blog.csdn.net/yzfuture2010/article/details/7799800
    [self initDisplayRenderBuffer];
    //stup4:绑定program
    [self initProgram];
    //stup4:绘制图形
    [self draw];
    //stup5:swap缓冲区,数据刷新
    [self flush];
    //释放资源
    [self releaseRes];
    
}


-(void)releaseRes{
    
    glUseProgram(0);
    
    if(_colorBufferRender) {
        glDeleteRenderbuffers(1, &_colorBufferRender);
        _colorBufferRender = 0;
    }
    if(_frameBuffer) {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    [EAGLContext setCurrentContext:nil];
    
}

-(void)flush{
    [_eglContext presentRenderbuffer:GL_RENDERBUFFER];
}

-(void)draw{
    //设置背景色
    [self glClearBackground];
    
    //设置视口
    glViewport(0, 0, _frameBufferWidth, _frameBufferHeight);
    
    //设置三角形顶点位置
    GLfloat vertex[] = {
        -0.5f,   -0.5f,   0.0f,
        0.0f,     0.5f,   0.0f,
        0.5f,    -0.5f,   0.0f
    };
    
    //设置顶点颜色数据
    GLfloat color[] = {
        0.0f, 0.0f, 1.0f, 1.0f,
        0.0f, 1.0f, 0.0f, 1.0f,
        1.0f, 0.0f, 0.0f, 1.0f,
    };
    
    //启用顶点属性
    glEnableVertexAttribArray(_vertexPos);
    glVertexAttribPointer(_vertexPos, 3, GL_FLOAT, GL_FALSE, 0, vertex);
    
    //启用颜色属性
    glEnableVertexAttribArray(_colorPos);
    glVertexAttribPointer(_colorPos, 4, GL_FLOAT, GL_FALSE, 0, color);
    
    //设置正交投影
//    float ratio = fabsf((float)self.view.bounds.size.height / (float)self.view.bounds.size.width);
//    GLKMatrix4 mvpMat4 = GLKMatrix4MakeOrtho(-1, 1, -ratio, ratio, -1.0f, 1.0f);
//    glUniformMatrix4fv(_mvp, 1, 0, mvpMat4.m);
    
    
    //启动绘制
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    //取消属性启用
    glDisableVertexAttribArray(_vertexPos);
    glDisableVertexAttribArray(_colorPos);

}

-(void)initDisplayRenderBuffer{
    
    //创建FBO
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    //创建RBO缓存
    glGenRenderbuffers(1, &_colorBufferRender);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorBufferRender);
    
    //绑定缓存
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorBufferRender);
    
    //绑定Context
    [_eglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eglLayer];
    
    //获取画布大小
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_frameBufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_frameBufferHeight);
    
    // 检测是否成功
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"创建缓存失败  %i", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
}

-(void)initProgram {
    _eglProgram = [GLUtils createProgramWithVertexShader:@"Triangle" fragmentShader:@"Triangle"];
    glUseProgram(_eglProgram);
    _vertexPos = glGetAttribLocation(_eglProgram, "position");
    _colorPos = glGetAttribLocation(_eglProgram, "color");
//    _mvp = glGetUniformLocation(_eglProgram, "mvp");
}

-(void)initEglDisplay {
    
    _eglLayer = [CAEAGLLayer layer];
    _eglLayer.frame = self.view.frame;
    [self.view.layer addSublayer:_eglLayer];
    _eglLayer.opaque = YES;
    _eglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];
    
}

-(void)glClearBackground{
    //清屏
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
}

-(void)initEglContext {
    _eglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_eglContext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
