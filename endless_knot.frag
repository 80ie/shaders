#ifdef GL_ES
precision highp float;
#endif

#include "lygia/math/const.glsl"
#include "lygia/space/rotate.glsl"

uniform vec2 u_resolution;
uniform float u_time;

const float ANGLE = 0.;
const float THREADS = 4.;

vec2 remap(vec2 uv) {
    return uv * 2. - 1.;
}

float rect(in vec2 st, in vec2 size) {
    //st = st / 2 + 1;
    size = 0.25 - size * 0.25;
    vec2 uv = smoothstep(size, size + size * vec2(0.0002), st * (1.0 - st));
    return uv.x * uv.y;
}

float box(vec2 _st, vec2 _size, float _smoothEdges) {
    _size = vec2(0.5) - _size * 0.5;
    vec2 aa = vec2(_smoothEdges * 0.5);
    vec2 uv = smoothstep(_size, _size + aa, _st);
    uv *= smoothstep(_size, _size + aa, vec2(1.0) - _st);
    return uv.x * uv.y;
}

vec3 thread(float t) {
    t = mod(t, 100.);
    if (t >= 50.) t = 100. - t;
    if (t < 5.) return vec3(.75, .58, .27);
    if (t < 48.) return vec3(.45, .05, .12);
    return vec3(1.0);
}

void main() {
    vec3 col = vec3(1.0);
    vec2 uv = (gl_FragCoord.xy - 0.5 * u_resolution) / u_resolution.y;

    uv = rotate(uv, radians(ANGLE), vec2(0.));

    float area = box(uv, vec2(0), 0.001);
    uv *= THREADS * 2.;
    vec2 id = floor(uv * area), f = fract(uv * area);

    float warp = step(0.5, 1.0 - sin(abs(id.x)));
    //float warp = smoothstep(-.1, .1, );
    //float weft = float(mod(id.x - 1., 2.) == 0.);
    col = vec3(f, 0.);

    //float alongFactor = 0.9 + 0.1 * sin(3.14159 * (over > .5 ? f.y : f.x));
    //float acrossFactor = 0.6 + .4 * sin(3.14159 * (over > .5 ? f.x : f.y));
    //col *= acrossFactor * alongFactor;

    gl_FragColor = vec4(col, 1.0);
}
