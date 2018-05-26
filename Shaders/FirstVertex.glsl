attribute vec4 position;
attribute vec4 color;

varying vec4 in_color;

void main(void) {
    gl_Position = position;
    in_color = color;
}
