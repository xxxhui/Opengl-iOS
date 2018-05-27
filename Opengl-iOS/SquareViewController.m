//
//  SquareViewController.m
//  Opengl-iOS
//
//  Created by semyon on 2018/5/27.
//  Copyright © 2018年 No Name. All rights reserved.
//

#import "SquareViewController.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "GLUtils.h"

@interface SquareViewController () {
    EAGLContext* _eglContext;
    CAEAGLLayer* _eglLayer;
    GLuint _eglProgram;
    GLuint _colorBufferRender; // RBO，渲染颜色缓冲区，后面可能用到深度缓冲区
    GLuint _frameBuffer;       // FBO
    GLuint _vertexPos;      // 用于绑定shader中的Position参数
    GLuint _colorPos;       // 用于绑定shader中的SourceColor参数
    GLint _frameBufferWidth; // 画布宽度
    GLint _frameBufferHeight; // 画布高度
}

@end

@implementation SquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self drawSquare];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)drawSquare {
    //stup1:设置context
    [self initEglContext];
    //stup2:设置display
    [self initEglDisplay];
    //stup3:绑定渲染缓存区
    [self initDisplayRenderBuffer];
    //stup4:绑定program
    [self initProgram];
    //stup4:绘制图形
    [self glClear];
    [self draw];
    //stup5:swap缓冲区,数据刷新
    [self flush];
    //释放资源
    [self releaseRes];
}

- (void)releaseRes{
    
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

- (void)flush {
    [_eglContext presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)draw {
    GLfloat vertex[] = {
        -0.5f,  0.5f, 0.0f,
        0.5f,  0.5f, 0.0f,
        0.5f, -0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f
    };
    
    //设置顶点颜色数据
    GLfloat color[] = {
        0.0f, 0.0f, 1.0f, 1.0f,
        0.0f, 1.0f, 0.0f, 1.0f,
        1.0f, 0.0f, 0.0f, 1.0f,
    };
    
    //启动顶点属性
    glEnableVertexAttribArray(_vertexPos);
    glVertexAttribPointer(_vertexPos, 3, GL_FLOAT, GL_FALSE, 0, vertex);
    
    //启用颜色属性
    glEnableVertexAttribArray(_colorPos);
    glVertexAttribPointer(_colorPos, 4, GL_FLOAT, GL_FALSE, 0, color);
    
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
    glDisableVertexAttribArray(_vertexPos);
    glDisableVertexAttribArray(_colorPos);
}

- (void)initDisplayRenderBuffer{
    
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glGenRenderbuffers(1, &_colorBufferRender);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorBufferRender);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorBufferRender);
    
    
    [_eglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eglLayer];
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_frameBufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_frameBufferHeight);
    
    // 检测是否成功
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Faild  %i", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
}

- (void)initProgram {
    _eglProgram = [GLUtils createProgramWithVertexShader:@"Square" fragmentShader:@"Square"];
    glUseProgram(_eglProgram);
    _vertexPos = glGetAttribLocation(_eglProgram, "position");
    _colorPos = glGetAttribLocation(_eglProgram, "color");
}

- (void)initEglDisplay {
    _eglLayer = [CAEAGLLayer layer];
    _eglLayer.frame = self.view.frame;
    [self.view.layer addSublayer:_eglLayer];
    _eglLayer.opaque = YES;
    _eglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];
    
}

- (void)glClear {
    //清屏
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    //设置视口
    glViewport(0, 0, _frameBufferWidth, _frameBufferHeight);
}

- (void)initEglContext {
    _eglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_eglContext];
}

@end
