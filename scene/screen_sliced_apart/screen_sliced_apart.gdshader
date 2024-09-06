shader_type canvas_item;

uniform vec2 angle = vec2(1,0);
uniform float amount : hint_range(0.0, 1.0, 0.001);
uniform vec3 cut_color : source_color;
uniform vec2 shift;
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x/SCREEN_PIXEL_SIZE.y;
	vec2 distorted = (SCREEN_UV-.5)/vec2(ratio,1.);

	distorted-=shift;

	float polarity = sign(dot(distorted, normalize(angle)));
	vec2 dir = normalize(angle);

	float override = 0.;
	if(abs(distorted.x*dir.x+distorted.y*dir.y)<amount){
		override = 1.;
	}

	distorted -= dir*polarity*amount;

	distorted+=shift;

	COLOR=texture(screen_texture, distorted*vec2(ratio,1.)+.5);
	COLOR.rgb=mix(COLOR.rgb,cut_color,override);
}
