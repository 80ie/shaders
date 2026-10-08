precision highp float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float pcurve( float x, float a, float b ){
    float k = pow(a+b,a+b) / (pow(a,a)*pow(b,b));
    return k * pow( x, a ) * pow( 1.0-x, b );
}

vec2 warp_uv(vec2 uv, float phase, float freq) {
    vec2 p = uv;
    float l = u_time;
    p -= 0.5;
    p.x *= u_resolution.x/u_resolution.y;
    l = length(p);
    uv += p / l*(sin(phase) + 1.0) * abs(sin(l * freq - 2.0*phase));
    return uv;
}

void main() {
    vec2 r = u_resolution;
    vec2 st = gl_FragCoord.xy / u_resolution.xy;
    vec3 color = vec3(0.0);
    vec2 grid_size = vec2(3.0);
    vec2 mouse = u_mouse/u_resolution;
    mouse.x *= r.x/r.y;

    st = warp_uv(st, u_time, 8.0);
    st *= grid_size;
    mouse *= grid_size;
    //st.x *= aspect;

    vec2 ist = floor(st);
    vec2 fst = fract(st);


    float m_dist = 1.;
    for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = neighbor + vec2(0.5);
            vec2 diff = neighbor + point - fst;
			float dist = length(diff);
			m_dist = min(m_dist, dist);
		}
	}

    float dist = distance(st, mouse);
    //m_dist = min(m_dist, dist);
    m_dist = pow(m_dist, 2.0);
    color += m_dist;

    gl_FragColor = vec4(color, 1.0);
}
