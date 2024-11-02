shader_type canvas_item;

uniform int iter : hint_range(1, 32, 1); // how many attempts to average up
uniform int samp : hint_range(1, 256, 1); // how many samples per attempt
uniform float bevel : hint_range(0.0, 1.0, 0.001); // keep TINY for the heuristics to work lmao
uniform float protrude : hint_range(0.0, 1.0, 0.001);

float image( sampler2D tex, float ratio, vec2 p )
{   
	float a= texture(tex, p/vec2(ratio, 1.) + .5).a;
	return mix(a, 1.-a, protrude);
}

float marcher( sampler2D tex, float ratio, vec2 p, float far ){
    if(image(tex, ratio, p)>.5){
        return 0.;
    }
    
    float dist = 0.;
    for(int j=0; j<iter; j++){
        float d = 0.;
        float diverge = 1.;
        for(int i=0; i<samp; i++){
            float perc = pow(float(i)/float(samp),2.);
            d = mix(d,perc*far,diverge);

            float ang = float(i*554+24+j);
            vec2 rd = vec2(cos(ang),sin(ang));
            if(image(tex, ratio, p + rd * d)>.5){
                diverge *= .1;
            }
        }
        dist += d;
    }
    dist/=float(iter);
    
    return dist/far;
}

void fragment() {
	float ratio = TEXTURE_PIXEL_SIZE.x/TEXTURE_PIXEL_SIZE.y;
	vec2 uv = (UV-.5)*vec2(ratio, 1.);
	
    vec2 ep = vec2(bevel/3.,0.);
    vec3 nor = vec3(
    marcher(TEXTURE, ratio, uv-ep, bevel)-marcher(TEXTURE, ratio, uv+ep, bevel),
    marcher(TEXTURE, ratio, uv-ep.yx, bevel)-marcher(TEXTURE, ratio, uv+ep.yx, bevel),
    0.
    );
    nor.z = 1.-max(abs(nor.x),abs(nor.y));
    nor = normalize(nor);

    vec3 col = mix(vec3(0),
		sin(vec3(4.,3.5,3.)+atan(nor.y,nor.x)*3.+TIME)+.5+vec3(.0,.1,.2),
    		1.-nor.z);
	
	COLOR.rgb = col;
}