const vec2 G = vec2(3.0);
const float SPIN = 0.00;
const float WARP = 0.6;
const float FREQ = 3.5;
const float WARP_SPEED = 0.1;
const float SHARP = 3.0;

// adapted from Danilo Guanabara's "Creation"
// https://www.shadertoy.com/view/XsXXDn
vec2 warp_uv(vec2 uv, float phase, float freq, float amount) {
    float l = length(uv);
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
    return pow(m_dist, sharp);
}

vec2 rot( vec2 uv, float angle ) {
    mat2 matrix = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    return matrix * uv;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 r = iResolution.xy;
    vec2 uv = fragCoord / r;

    uv -= 0.5;
    uv.x *= r.x/r.y;
    uv *= G;

    float phase = iTime*WARP_SPEED;
    vec2 p = warp_uv(uv, phase, FREQ, WARP);
    p = rot(p, -iTime*SPIN);

    float d = grid(uv*p, SHARP);
    d = smoothstep(0.0, 0.7, d);

    fragColor = vec4(vec3(d), 1.0);
}
