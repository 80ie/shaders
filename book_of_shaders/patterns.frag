#ifdef GL_ES
precision mediump float;
#endif
#define PI 3.14159265359

uniform vec2 u_resolution;
uniform float u_time;

vec2 tile(vec2 uv, float size) {
    uv *= size;
    uv = fract(uv);
    return uv;
}

float rect(vec2 uv, float size) {
    vec2 bl = step(vec2(size), uv);
    float pct = bl.x * bl.y;

    vec2 tr = step(vec2(size), 1.0 - uv);
    pct *= tr.x * tr.y;

    return pct;
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    uv.x *= u_resolution.x / u_resolution.y;
    //vec2 st = tile(uv, 3.0);
    uv = tile(uv, 3.0);

    uv -= vec2(0.5);
    uv *= 2;

    //float pct = rect(uv, 0.05);
    float dx = pow(min(cos(PI * uv.x / 2.0), 1.0 - abs(uv.x)), 2.0);

    vec3 color = vec3(dx);

    gl_FragColor = vec4(color, 1.0);
}
