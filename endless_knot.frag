#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
const float ANGLE = -45.;
const float SIZE = 9.;
const float WIDTH = .20;

vec3 thread(float t) {
    if (t > WIDTH) return vec3(1.0);
    if (t > WIDTH - .03) return vec3(0.);
    return vec3(.88, .65, .0);
}

void main() {
    vec3 col = vec3(1.0);
    vec2 uv = (gl_FragCoord.xy - 0.5 * u_resolution) / u_resolution.y;

    float a = radians(ANGLE);
    vec2 r = vec2(dot(uv, vec2(-sin(a), cos(a))), dot(uv, vec2(cos(a), sin(a))));
    r *= SIZE;

    vec2 id = floor(r), f = fract(r);

    float tx = float(distance(f.x, 0.5) <= WIDTH);
    float ty = float(distance(f.y, 0.5) <= WIDTH);
    float over = float(mod(id.x - id.y, 2.) < 1.);

    float top = (over < 1.) ? tx : ty;
    float bottom = (over < 1.) ? ty : tx;
    float m = 1.0 - step(top, f.x);
    //col = mix(top, bottom, m);
    //col = vec3(m);

    gl_FragColor = vec4(col, 1.);
}
