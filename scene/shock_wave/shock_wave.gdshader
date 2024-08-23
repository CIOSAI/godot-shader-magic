shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float edge : hint_range(0.0, 2.0, 0.01);
uniform float width : hint_range(0.01, .5, 0.01);
uniform float amp : hint_range(0.0, 1.0, 0.01);

void fragment() {
	vec2 uv=SCREEN_UV;
	
	float ratio=SCREEN_PIXEL_SIZE.x/SCREEN_PIXEL_SIZE.y;
	uv-=.5; // put (0,0) in the center
	uv.x/=ratio; // adjust screen ratio
	
	float dist_from_edge=abs(length(uv)-edge)/width;
	
	uv+=normalize(uv)*(1.-pow(smoothstep(0.,1.,dist_from_edge),2.))*amp;
	
	uv.x*=ratio; // adjust back to normalized
	uv+=.5; // put (0,0) back to bottom left
	COLOR=texture(screen_texture, uv);
}