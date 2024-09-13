shader_type canvas_item;

uniform float spatial_reso : hint_range(1, 640, 1);
uniform int dither_layer : hint_range(1, 4, 1);
uniform float gate_curve : hint_range(0.01, 2.0, 0.01);

float pattern(int layer, vec2 id) {
	float acc = 0.;
	for(int i=1; i<=layer; i++){
		float pat[] = {2.0, 0.0, 1.0, 3.0};
		vec2 p = mod(floor(id/float(2<<i)),2.);
		acc += (pat[int(p.y)*2+int(p.x)])*float(2<<(i-1));
	}
	return pow(acc/pow(4.0,float(layer)),gate_curve);
}

void fragment() {
	float ratio = 16./9.;
	vec2 uv = (UV-.5)*vec2(ratio,1.);
	vec2 id = floor(uv*spatial_reso);
	
	uv = floor(uv*spatial_reso)/spatial_reso;
	
	vec4 samp = texture(TEXTURE, uv/vec2(ratio,1.)+.5);
	
	COLOR = step(vec4(pattern(dither_layer, id)), samp);
}