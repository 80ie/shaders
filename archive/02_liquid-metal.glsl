precision highp float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

const vec2 g = vec2(2.0); // GRID SIZE

vec2 r = u_resolution;
vec2 mouse = u_mouse/r;


vec2 warp_uv(vec2 uv, float phase, float freq) {
    float l = u_time;
    l = length(uv);
    uv += uv / l*(sin(phase) + 1.0) * abs(sin(l * freq - 2.0*phase));
    return uv;
}

float grid(vec2 uv, vec2 grid_size) {
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
    m_dist = pow(m_dist, 2.0);
    return m_dist;
}

vec2 rot( vec2 uv, float angle ) {
    mat2 matrix = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    uv = matrix * uv;
    return uv;
}

void main() {
    vec2 uv = gl_FragCoord.xy / r.xy;
    vec3 color = vec3(0.0);
    vec3 c;
    
    
    uv -= 0.5;
    uv.x *= r.x/r.y;
    uv *= g;
    mouse *= g;
    
    uv = rot(uv, u_time*0.3);
    vec2 p = warp_uv(uv, u_time, 9.0);
    p = rot(p, -u_time*0.3);
    
    float d = grid(uv/p, g); 
    color += d;
    
    gl_FragColor = vec4(color, 1.0);
}
