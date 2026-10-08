precision highp float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;


vec2 warp_uv(vec2 uv, float phase, float freq) {
    vec2 p = uv;
    p -= 0.5;
    p.x *= u_resolution.x/u_resolution.y;
    float l = length(p);
    uv += p / l*(sin(phase) + 1.0) * abs(sin(l * freq - 2.0*phase));
    return uv;
}

void main() {
    vec3 c;
    vec2 r = u_resolution;
    float t = u_time;
    float l, z = t;    
    for (int i=0; i < 3; i++) {
        vec2 uv, p = gl_FragCoord.xy / r.xy;
        uv = p;
        p -= 0.5;
        p.x *= r.x/r.y;
        z += 0.07;
        l = length(p);
        uv += p/l*(sin(z) + 1.0) * abs(sin(l*9.0-z-z));
        c[i] = 0.01 / length( mod(uv,1.0) - 0.5 );
    }
    gl_FragColor=vec4(c/l, 1.0);
}