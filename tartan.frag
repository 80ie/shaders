#ifdef GL_ES
precision highp float;
#endif

#include "lygia/math/const.glsl"
#include "lygia/color/hueShift.glsl"

uniform vec2 u_resolution;
const float ZOOM = 10.;
const float ANGLE = 30.;

vec3 thread(float t) {
    t = mod(t, 100.);
    if (t >= 50.) t = 100. - t;
    if (t < 5.) return vec3(0.1);
    if (t < 14.) return vec3(1.2);
    if (t < 23.) return vec3(0.1);
    if (t < 49.) return vec3(0.90);
    return vec3(1.0, .05, 0.);
}

void main() {
    vec2 q = gl_FragCoord.xy / vec2(ZOOM);

    float a = radians(ANGLE);
    vec2 r = vec2(dot(q, vec2(-sin(a), cos(a))), dot(q, vec2(cos(a), sin(a))));

    vec2 id = floor(r), f = fract(r);

    vec3 warp = thread(id.x);
    vec3 weft = thread(id.y);

    float over = float(mod(id.x - id.y, 3.) < 2.);
    vec3 col = mix(weft, warp, over);

    float alongFactor = 0.9 + 0.1 * sin(3.14159 * (over > .5 ? f.y : f.x));
    float acrossFactor = 0.6 + .4 * sin(3.14159 * (over > .5 ? f.x : f.y));
    col *= acrossFactor * alongFactor;
    gl_FragColor = vec4(col, 1.);
}
