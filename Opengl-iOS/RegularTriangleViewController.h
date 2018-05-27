//
//  RegularTriangleViewController.h
//  Opengl-iOS
//
//  Created by xxxhui on 2018/5/26.
//  Copyright © 2018年 No Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "AGLKVertexAttribArrayBuffer.h"

@interface RegularTriangleViewController : GLKViewController

@property (strong, nonatomic) GLKBaseEffect* baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer* vertexBuffer;

@end
