//
//  GLUtils.h
//  Opengl-iOS
//
//  Created by xxxhui on 2018/5/23.
//  Copyright © 2018年 No Name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface GLUtils : NSObject
+ (GLuint)createProgramWithVertexShader:(NSString *)vertexShader fragmentShader:(NSString *)fragmentShader;
@end
