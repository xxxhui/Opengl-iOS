attribute vec4 position;
attribute vec4 color;
//uniform mat4 mvp;

varying vec4 in_color;

void main(void) {
    //gl_Position = mvp * position;
    gl_Position = position;
    in_color = color;
}
