// Example Pixel Shader

// uniform float exampleUniform;
uniform vec2 u_resolution;
uniform vec2 u_grid;
uniform float u_time;
uniform float u_radius;
uniform float u_mouse;
uniform float u_min_dist;

float circle(in vec2 _st, in float _radius){
    vec2 l = _st-vec2(0.5);
    return 1.-smoothstep(_radius-(_radius*0.01),
                         _radius+(_radius*0.01),
                         dot(l,l)*4.0);
}


out vec4 fragColor;	
void main()
{
	vec2 st = vUV.st*u_grid.xy;
	vec3 color = vec3(vUV.s, vUV.t, 0.0);
	
	// Tile the space
    vec2 i_st = floor(st);
    vec2 f_st = fract(st);
	
	//st = fract(st);
	
	vec2 point = u_mouse/u_resolution;
	
	
	
    color = vec3(f_st,0.0);
    color = vec3(circle(f_st,u_radius));

	fragColor = TDOutputSwizzle(vec4(color, 1.0));
}