precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

const float FREQ = 5.0;
const float GRID_SIZE = 5.0;
const float speed = 0.2;

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
    //r.xy = (p.x > 0.0) ? r.xy : r.zw;
    //r.x  = (p.y > 0.0) ? r.x  : r.y;
    vec2 q = abs(p) - b + r.x;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r.x;
}

vec2 toCanvas(vec2 st) {
    return (st - 0.5 * u_resolution.xy) / u_resolution.y * GRID_SIZE;
}

float pcurve( float x, float a, float b ){
    float k = pow(a+b,a+b) / (pow(a,a)*pow(b,b));
    return k * pow( x, a ) * pow( 1.0-x, b );
}


void main() 
{
    vec2 uv = toCanvas(gl_FragCoord.xy);
    //uv *= 2.0;
    vec2 mouse = toCanvas(u_mouse);

    vec2 uvi = floor(uv + 0.5);
    vec2 uvf = uv - uvi;

    float box = sdRoundedBox(uvf, vec2(0.3), vec4(0.0,0.3,0.0,0.0));
    box = smoothstep(.0, 0.5, box);
    
    float d = length(uv-mouse);
    vec2 o = mouse - 0.3;
    float dir = min((o.x,o.y),0.0) + length(max(uv, 0.0)); 
    
   
    float glow = 1.0 - smoothstep(0.0, 3.0, abs(d)*0.5);
    
    float phase = d / FREQ - u_time * speed;
    float wave = sin(phase * 6.28318530718) * 0.5 + 0.5;
    wave = pow(wave, 5.0);
    
    float col = 1.0 - box * glow + wave;
    
    vec3 color = vec3(dir);
    
    
    
    
    //color = vec3(uv,0.0);
    //color = vec3(col);
    
    gl_FragColor = vec4(color, 0.5);
}