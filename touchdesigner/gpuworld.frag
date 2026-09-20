uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

uniform float u_frequency;
uniform float u_gridsize;
uniform float u_speed;

vec3 palette( float t ) { 
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
//    return (pixelCoord - 0.5 * u_resolution.xy) / u_resolution.y * u_gridsize;
	vec2 uv = (pixelCoord - 0.5) * u_gridsize;
	uv.y *= u_resolution.x/u_resolution.y;
	//pixelCoord.y *= u_resolution.y/u_resolution.x;
	// *= u_gridsize;
	return uv;
}

float pcurve( float x, float a, float b ){
    float k = pow(a+b,a+b) / (pow(a,a)*pow(b,b));
    return k * pow( x, a ) * pow( 1.0-x, b );
}

out vec4 fragColor;
void main() 
{
    vec2 uv = toCanvas(vUV.st);
	vec2 mouse = toCanvas(u_mouse);

    vec2 cell_id = floor(uv + 0.5);
    vec2 cell_uv = uv - cell_id;
    //vec2 cell_uv = fract(uv + 0.5);

    float box = sdRoundedBox(cell_uv, vec2(0.3), vec4(0.1));
    box = mix(0.0, 1.0, box); 
    box = smoothstep(.0, 0.5, box);
    
    float d = length(uv-mouse);
	//float glow = 1.0 - smoothstep(0.0, 5.0, length(cell_id-mouse));
	vec2 p = cell_id - mouse;
    float glow = 1.0 - smoothstep(0.0, 5.0, length(p));
    //glow = length(abs(cell_id)-cell_uv);
	//glow = sdRoundedBox(uv, vec2(length(mouse - abs(cell_id))), vec4(0.1));
	//glow = 1.0 - smoothstep(0.0, 1.0, glow);
    //float wave = sin(d - u_time * speed);
    
	float phase = d / u_frequency - u_time * u_speed;
    float wave = sin(phase * 6.28318530718) * 0.5 + 0.5;
    wave = pow(wave, 5.0);
    //wave = abs(wave);
    
    vec3 bg = palette(fract(u_time*0.05)); 
    //vec3 color = vec3(1.0 - box - wave * glow);
    vec3 color = vec3(box + wave, glow, 0.0);
	color = vec3(glow);
    fragColor = TDOutputSwizzle(vec4(color, 1.0));
}