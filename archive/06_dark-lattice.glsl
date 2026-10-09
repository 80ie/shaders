precision highp float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

const vec2 G = vec2(3.0);
const float SPIN = 0.00;
const float WARP = 0.6;
const float FREQ = 3.5;
const float WARP_SPEED = 0.1;
const float SHARP = 3.0;

// adapted from Danilo Guanabara's "Creation"
// https://www.shadertoy.com/view/XsXXDn
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

vec3 palette( float t )
{ 
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(0.15, 0.1843, 0.2);
    vec3 d = vec3(0.7373, 0.7373, 0.8118);	

    return a + b*cos( 6.28318*(c*t+d) );
}

void main() {
    vec2 r = u_resolution;
    vec2 uv = gl_FragCoord.xy / r.xy;
    vec2 mouse = u_mouse/r;
    vec3 color = vec3(0.0);
    vec3 c = vec3(0.0);

    uv -= 0.5;
    uv.x *= r.x/r.y;
    uv *= G;
    mouse *= G;


    //uv = rot(uv, u_time*SPIN);
    float phase = u_time*WARP_SPEED;
    vec2 p = warp_uv(uv, phase, FREQ, WARP);
    p = rot(p, -u_time*SPIN);

    float d = grid(uv*p, SHARP);
//    d = pow(d, 2.0);
    d = smoothstep(0.0, 0.7,d);
    
    c = vec3(d);

    
    gl_FragColor = vec4(c, 1.0);
}
