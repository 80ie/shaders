#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
const float ZOOM = 10.;
const float ANGLE = 30.;

vec3 thread(float t) {
    t = mod(t, 100.);
    if (t >= 50.) t = 99. - t;
    if (t < 5.) return vec3(0.0);
    if (t < 15.) return vec3(0.9);
    if (t < 25.) return vec3(0.0);
    if (t < 48.) return vec3(0.8);
    return vec3(.8, .05, .05);
}

void main() {
    vec2 q = gl_FragCoord.xy / vec2(ZOOM);

    float a = radians(ANGLE);
    vec2 r = vec2(dot(q, vec2(-sin(a), cos(a))), dot(q, vec2(cos(a), sin(a))));

    vec2 id = floor(r), f = fract(r);

    vec3 warp = thread(id.x);
    vec3 weft = thread(id.y);

    float over = float(mod(id.x - id.y, 4.) < 2.);
    vec3 col = mix(weft, warp, over);

    float acrossFactor = 0.6 + .4 * sin(3.14159 * (over > .5 ? f.x : f.y));
    float alongFactor = 0.9 + 0.1 * sin(3.14159 * (over > .5 ? f.y : f.x));
    col *= alongFactor * acrossFactor;
    gl_FragColor = vec4(col, 1.);
}
