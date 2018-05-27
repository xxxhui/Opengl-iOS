attribute vec4 position;
attribute vec4 color;
uniform mat4 uModelViewProjectionMatrix;

varying vec4 in_color;

void main(void) {
    gl_Position = uModelViewProjectionMatrix * position;
    in_color = color;
}
