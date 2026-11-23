#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
const float ANGLE = -45.;
const float SIZE = 8.; // zoom
const float WIDTH = .20; // thread width
const float CELLS = 4.; // NxN crosses

const vec3 BG = vec3(1.0);
const vec3 FILL = vec3(.88, .65, .0);
const vec3 BORDER = vec3(0.);
const float BORDER_WIDTH = .03;

#include "debug_grid.glsl"

vec3 thread(float t) {
    if (t > WIDTH) return BG;
    if (t > WIDTH - BORDER_WIDTH) return BORDER;
    return FILL;
}

// Pre: grid centered on (0,0)
bool isInside(vec2 id, vec2 area) {
    return ((abs(id.x + .5) < area.x / 2.) && (abs(id.y + .5) < area.y / 2.));
}
/*
float elbow(vec2 f, vec2 dir) {
    float dx = distance(f.x, 0.5);
    float dy = distance(f.y, 0.5);
    float a = dir.x > 0 ? 0.5 - f.y : f.y - 0.5;
    float dc = dir.x > 0 ? 0.5 - f.y : f.y - 0.5;
    return min(max(dx,dc), max())
}*/

void main() {
    vec3 col = vec3(1.0);
    vec2 uv = (gl_FragCoord.xy - 0.5 * u_resolution) / u_resolution.y;

    float a = radians(ANGLE);
    vec2 r = vec2(dot(uv, vec2(-sin(a), cos(a))), dot(uv, vec2(cos(a), sin(a))));
    r *= SIZE;

    vec2 id = floor(r), f = fract(r);

    float dx = distance(f.x, 0.5);
    float dy = distance(f.y, 0.5);

    float over = float(mod(id.x - id.y, 2.) < 1.);

    vec3 cx = thread((dx <= WIDTH) ? dx : dy);
    vec3 cy = thread((dy <= WIDTH) ? dy : dx);

    col = mix(cx, cy, over);
    bool inner = isInside(id, vec2(CELLS));
    col = (inner) ? col : BG;

    bool outer = (isInside(id, vec2(CELLS + 2.)) && !inner);

    float lu = (mod(abs(id.x), 2.) < 1.) ? f.x : 0.5;
    float ld = (mod(abs(id.x), 2.) < 1.) ? 0.5 : f.x;
    float ll = (mod(abs(id.y), 2.) < 1.) ? f.y : 0.5;
    float lr = (mod(abs(id.y), 2.) < 1.) ? 0.5 : f.y;

    float hy = max(dy, lu - ld);
    float hx = max(dx, ll - lr);

    vec3 corner = thread(min(hx, hy));

    col = (outer) ? corner : col;

    //col = debugGrid(col, r);
    gl_FragColor = vec4(col, 1.);
}
