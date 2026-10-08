precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

const float GRID_SIZE   = 1.0;  // cells across the short axis
const vec2 SIZE = vec2(0.1);

vec2 toCanvasSpace(vec2 pixelCoord)
{
    return (pixelCoord - 0.5 * u_resolution.xy) / u_resolution.y * GRID_SIZE;
}

// b = half extents
// r = corner radii: x top-right, y bottom-right, z top-left, w bottom-left
float sdRoundedBox(in vec2 p, in vec2 b, in vec4 r)
{
    r.xy = (p.x > 0.0) ? r.xy : r.zw;
    r.x  = (p.y > 0.0) ? r.x  : r.y;
    vec2 q = abs(p) - b + r.x;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r.x;
}

void main() 
{
    float aspect = u_resolution.x / u_resolution.y; 
    vec2 uv = toCanvasSpace(gl_FragCoord.xy);
    vec2 mouse = toCanvasSpace(u_mouse); 

    float box = sdRoundedBox(uv, vec2(SIZE), vec4(0.0));
    //box = step(box, 0.15);

    float glow = 1.0 - smoothstep(0.0, 1.0, length(uv - mouse));

    float dst = smoothstep(0.0, 0.5, length(uv - mouse));    

    float intensity = 1.0 - box*glow;
    vec3 color = vec3(box);
    //color *= dst;
    gl_FragColor = vec4(color, 1.0);
}
