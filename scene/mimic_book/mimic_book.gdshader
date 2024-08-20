shader_type canvas_item;

// left and right pages
uniform sampler2D L;
uniform sampler2D R;
uniform vec2 page_size;
uniform float flip_progress : hint_range(0.0, 1.0, 0.01);
uniform float curve : hint_range(-1.0, 1.0, 0.01);
// pseudo view angle
uniform float angle : hint_range(0.0, 2.0, 0.01);
// how much space does it have to curve "out of the picture"
uniform float room;

void vertex() {
	// extend the quad upwards and downwards
	VERTEX.y += sign(VERTEX.y-.5)*room;
	if(VERTEX.x<.5){ // vertices on the right
		// rotation
		VERTEX -= cos(vec2(flip_progress*PI,-flip_progress*PI+PI/2.))
		*page_size
		*vec2(1,angle)
		-vec2(page_size.x,0);
	}
}

void fragment() {
	// converting local coords to normalized coords
	float ang_off = 2.*room/page_size.y;
	float page = 0.;
	// convert the taller(extended by vertex()) UV back
	vec2 uv = UV*vec2(1,1.+ang_off)-vec2(0,ang_off*.5);
	if(flip_progress>.5){
		uv.x = 1.-uv.x; // flip it back (vertex() flipped it around horizontally)
		page = 1.;
	}
	// pure magic, i genuinely forgot
	uv.y-=(1.-abs(flip_progress-.5)*2.)*pow(1.-abs(uv.x-.5)*2.,.5)*curve;
	COLOR.rgb=mix(texture(L,uv).rgb,texture(R,uv).rgb,page);
	// cut out the parts of the uv that goes outside the image
	COLOR.a=smoothstep(abs(uv.y-.5)-SCREEN_PIXEL_SIZE.y,abs(uv.y-.5),.5);
}