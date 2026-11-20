
uniform vec2 u_resolution;

// sett: 10,2,10,2,24,2 = 50 threads, mirrored to 100
vec3 thread(float t) {
    t = mod(t, 100.);
    if (t >= 50.) t = 99. - t;
    if (t < 10.) return vec3(.05, .20, .10); // green
    if (t < 12.) return vec3(.90, .80, .20); // yellow
    if (t < 22.) return vec3(.05, .20, .10); // green
    if (t < 24.) return vec3(.70, .05, .05); // red
    if (t < 48.) return vec3(.05, .10, .30); // navy
    return vec3(.90); // white
}

void main() {
    vec2 p = gl_FragCoord.xy / 6.; // 6 px per thread
    vec2 id = floor(p), f = fract(p);

    vec3 warp = thread(id.x);
    vec3 weft = thread(id.y);

    float over = float(mod(id.x + id.y, 4.) < 2.); // 2/2 twill
    vec3 col = mix(weft, warp, over);

    col *= .6 + .4 * sin(3.14159 * (over > .5 ? f.x : f.y));
    gl_FragColor = vec4(col, 1.);
}
