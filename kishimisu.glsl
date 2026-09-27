precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

const float FREQ = 5.0;
const float GRID_SIZE = 5.0;
const float speed = 0.15;

vec3 palette( float t )
{ 
    vec3 a = vec3(0.5);
    vec3 b = vec3(0.5);
    vec3 c = vec3(1.0);
    vec3 d = vec3(0.0, 0.33, 0.67);	

    return a + b*cos( 6.28318*(c*t+d) );
}

float sdRoundedBox(in vec2 p, in vec2 b, in vec4 r) {
    // b = half extents
    // r = corner radii: x top-right, y bottom-right, z top-left, w bottom-left
    r.xy = (p.x > 0.0) ? r.xy : r.zw;
    r.x  = (p.y > 0.0) ? r.x  : r.y;
    vec2 q = abs(p) - b + r.x;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r.x;
}

vec2 toCanvas(vec2 pixelCoord) {
    return (pixelCoord - 0.5 * u_resolution.xy) / u_resolution.y * GRID_SIZE;
}

float pcurve( float x, float a, float b ){
    float k = pow(a+b,a+b) / (pow(a,a)*pow(b,b));
    return k * pow( x, a ) * pow( 1.0-x, b );
}

void main() 
{
    vec2 uv = toCanvas(gl_FragCoord.xy);
    vec2 mouse = toCanvas(u_mouse);

    vec3 rainbow = palette(fract(u_time*0.05)); 

    vec2 uvi = floor(uv + 0.5 );
    vec2 uvf = uv - uvi;
    //vec2 uvf = fract(uv + 0.5);

    float box = sdRoundedBox(uvf, vec2(0.35), vec4(0.1));
    box = mix(0.0, 1.0, box); 
    box = smoothstep(.0, 0.5, box);
    
    float d = length(uv-mouse);
    float glow = 1.0 - smoothstep(0.0, 3.0, length(uvi - mouse));
    //float wave = sin(d - u_time * speed);
    float phase = d / FREQ - u_time * speed;
    float wave = sin(phase * 6.28318530718) * 0.5 + 0.5;
    wave = pow(wave, 4.0);
    wave = fract(u_time*0.1)*wave;
    //wave = abs(wave);
    
    //vec3 bg = palette(fract(u_time*0.05)); 

    //wave = palette(fract(u_time*0.1)*wave);
    float col = 1.0 - box - wave * glow; 
    vec3 color = vec3(col);
    //vec3 color = vec3(box+wave);
    //color = vec3(uvf.x, uvf.y, 0.0);
    //color = vec3(corner);
    //color = palette(box)+wave;
    gl_FragColor = vec4(color, 1.0);
}