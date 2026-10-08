precision highp float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// 0..1 sliders from glsl-canvas.uniforms in .vscode/settings.json
uniform float u_zoom;
uniform float u_spin;
uniform float u_warp;
uniform float u_freq;
uniform float u_wspeed;
uniform float u_sharp;
uniform vec3 u_tint;


vec2 warp_uv(vec2 uv, float phase, float freq, float amount) {
    float l = u_time;
    l = length(uv);
    uv += uv / l*(sin(phase) + 1.0) * abs(sin(l * freq - 2.0*phase)) * amount;
    return uv;
}

float grid(vec2 uv, float sharp) {
    vec2 f = fract(uv);
    float m_dist = 1.;
    for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = neighbor + vec2(0.5);
            vec2 diff = neighbor + point - f;
			float dist = length(diff);
			m_dist = min(m_dist, dist);
		}
	}
    m_dist = pow(m_dist, sharp);
    return m_dist;
}

vec2 rot( vec2 uv, float angle ) {
    mat2 matrix = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    uv = matrix * uv;
    return uv;
}

void main() {
    vec2 r = u_resolution;
    vec2 uv = gl_FragCoord.xy / r.xy;
    vec2 mouse = u_mouse/r;
    vec3 color = vec3(0.0);
    vec3 c;

    vec2 g = vec2(mix(0.5, 8.0, u_zoom));
    float spin = (u_spin - 0.5) * 3.0;

    uv.x *= r.x/r.y;
    uv -= 0.5;
    uv *= g;
    mouse *= g;


    for (int i=0; i < 3; i++) {
        uv = rot(uv, u_time*spin);
        vec2 p = warp_uv(uv, u_time*u_wspeed*2.0, u_freq*20.0, u_warp*2.0);
        p = rot(p, -u_time*spin);

        float d = grid(uv+p, mix(0.5, 6.5, u_sharp));
        c += d * u_tint;
    }    
    gl_FragColor = vec4(c, 1.0);
}
