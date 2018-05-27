//
//  RegularTriangleViewController.m
//  Opengl-iOS
//
//  此Demo引入了GLKit框架。增加mvp矩阵。画一个正三角形。
//
//  Created by xxxhui on 2018/5/26.
//  Copyright © 2018年 No Name. All rights reserved.
//

#import "RegularTriangleViewController.h"
#import "AGLKContext.h"
#import "GLUtils.h"
#import <stddef.h>

enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    NUM_UNIFORMS
};

@interface RegularTriangleViewController()
{
    GLuint _program;
    
    GLuint _vertexPos;
    GLuint _colorPos;
    GLuint _texture0ID;
    GLuint _texture1ID;
    GLint uniforms[NUM_UNIFORMS];
}

@end

typedef struct {
    GLKVector3  positionCoords;
    GLKVector4  positionColors;
}
SceneVertex;

static const SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0}, {0.0f, 0.0f, 1.0f, 1.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0}, {1.0f, 0.0f, 0.0f, 1.0f}}, // lower right corner
    {{0.0f,  0.5f, 0.0}, {0.0f, 1.0f, 0.0f, 1.0f}}  // upper left corner
};

@implementation RegularTriangleViewController

@synthesize vertexBuffer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取glkview
    GLKView* view = (GLKView *)self.view;
    //设置上下文
    view.context = [[AGLKContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;

    [AGLKContext setCurrentContext:view.context];

    [self loadShaders];

    self.baseEffect = [[GLKBaseEffect alloc] init];

    //启用深度测试
    glEnable(GL_DEPTH_TEST);

    // 设置背景色
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(
               1.0f, // Red
               1.0f, // Green
               1.0f, // Blue
               1.0f);// Alpha

    // 关联顶点数据
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                         bytes:vertices
                         usage:GL_STATIC_DRAW];
    
 
}

-(void) loadShaders {
    _program = [GLUtils createProgramWithVertexShader:@"RegularTriangle" fragmentShader:@"RegularTriangle"];
    NSAssert(_program != 0,@"Fail program");

    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribColor, "color");

    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "uModelViewProjectionMatrix");
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    
    float ratio = fabsf((float)self.view.bounds.size.height / (float)self.view.bounds.size.width);
    GLKMatrix4 mvp = GLKMatrix4MakeOrtho(-1, 1, -ratio, ratio, -1.0f, 1.0f);//此处创建正交投影矩阵。模型和相机为默认单位矩阵。
    
    self.baseEffect.transform.projectionMatrix = mvp;

    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribColor
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionColors)
                                  shouldEnable:YES];

    [self.baseEffect prepareToDraw];

    // 绘制三角形
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)];
}

@end
