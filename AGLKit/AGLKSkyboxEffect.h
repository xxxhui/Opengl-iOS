//
//  AGLKSkyboxEffect.h
//  
//

#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface AGLKSkyboxEffect : NSObject <GLKNamedEffect>

@property (nonatomic, assign) GLKVector3 center;                
@property (nonatomic, assign) GLfloat xSize;
@property (nonatomic, assign) GLfloat ySize;
@property (nonatomic, assign) GLfloat zSize;
@property (strong, nonatomic, readonly) GLKEffectPropertyTexture 
   *textureCubeMap;
@property (strong, nonatomic, readonly) GLKEffectPropertyTransform         
   *transform;

- (void) prepareToDraw;
- (void) draw;
   
@end
