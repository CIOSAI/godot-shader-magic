shader_type canvas_item;

uniform float edge_strength : hint_range(0.0, 20.0, 0.01);
uniform vec3 edge_color : source_color;
uniform vec2 scroll;
uniform float distort : hint_range(1.0, 2.0, 0.01);
uniform float scale : hint_range(0.0, 2.0, 0.01);
uniform sampler2D noise : repeat_enable;

void fragment() {
	float px = 0.015;
	float circle = length(UV-.5)-.5;

	float fresnel = pow(1.+circle*2.,edge_strength);
	float mask = smoothstep(0.,-px,circle);
	vec4 samp = texture(noise,(UV-.5)*-log(1.-length(UV-.5)*distort)*scale+scroll*scale*TIME);
	vec3 col = mix(samp.rgb,edge_color,fresnel);
	COLOR=vec4(col,mask*min(1.,samp.a+fresnel));
}