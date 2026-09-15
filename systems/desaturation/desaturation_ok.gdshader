shader_type canvas_item;

uniform float lighten_modifier : hint_range(0.0,1.0,0.01) = 0.0;

uniform float red_scale : hint_range(0.0, 1.0, 0.1);
uniform float yellow_scale : hint_range(0.0, 1.0, 0.1);
uniform float blue_scale : hint_range(0.0, 1.0, 0.1);
//const vec3 grey_scale = vec3(0.2,0.2,0.2);

vec3 rgb_to_oklch(vec3 c) 
{
    float l = 0.4122214708f * c.r + 0.5363325363f * c.g + 0.0514459929f * c.b;
	float m = 0.2119034982f * c.r + 0.6806995451f * c.g + 0.1073969566f * c.b;
	float s = 0.0883024619f * c.r + 0.2817188376f * c.g + 0.6299787005f * c.b;

    float l_ = pow(l,1.0/3.0);
    float m_ = pow(m,1.0/3.0);
    float s_ = pow(s,1.0/3.0);

	vec3 oklab = vec3(
        0.2104542553f*l_ + 0.7936177850f*m_ - 0.0040720468f*s_,
        1.9779984951f*l_ - 2.4285922050f*m_ + 0.4505937099f*s_,
        0.0259040371f*l_ + 0.7827717662f*m_ - 0.8086757660f*s_
    );
    return vec3(
		oklab.x,
		sqrt(oklab.y*oklab.y+oklab.z*oklab.z),
		atan(oklab.z,oklab.y)
	);
}

vec3 oklch_to_rgb(vec3 oklch) 
{
	vec3 c = vec3(
		oklch.x,
		oklch.y * cos(oklch.z),
		oklch.y * sin(oklch.z)
	);
	
    float l_ = c.x + 0.3963377774f * c.y + 0.2158037573f * c.z;
    float m_ = c.x - 0.1055613458f * c.y - 0.0638541728f * c.z;
    float s_ = c.x - 0.0894841775f * c.y - 1.2914855480f * c.z;

    float l = l_*l_*l_;
    float m = m_*m_*m_;
    float s = s_*s_*s_;

    return vec3(
		+4.0767416621f * l - 3.3077115913f * m + 0.2309699292f * s,
		-1.2684380046f * l + 2.6097574011f * m - 0.3413193965f * s,
		-0.0041960863f * l - 0.7034186147f * m + 1.7076147010f * s
    );
}

float ratio(float a, float b){
	float sum = a + b;
	if(sum == 0.0){
		return 0.0;
	}
	if(b == 0.0){
		return 0.0;
	}
	if(a == 0.0){
		return 1.0;
	}
	return b/sum;
}

void fragment() {
	vec3 ok = rgb_to_oklch(COLOR.rgb);
	
	//swapped so I don't have to flip around the x y & zs for the code below
	vec3 ok_hcl = vec3(ok.z,ok.y,ok.x);
	
	//vec3 hsl = rgb_to_hsl(COLOR.rgb);
	vec3 new_ok_hcl = ok_hcl;
	
	
	if(ok_hcl.x < 60.0){
		//RED-YELLOw
		float sat = mix(mix(0.0,ok_hcl.y,red_scale),mix(0.0,ok_hcl.y,yellow_scale),distance(0.0,ok_hcl.x)/60.0);
		new_ok_hcl.z = mix(ok_hcl.z+lighten_modifier,ok_hcl.z,sat/ok_hcl.y);
		new_ok_hcl.y = sat;
		float red_paint = distance(60.0,ok_hcl.x)/60.0;
		float yellow_paint = 1.0-red_paint;
		red_paint = mix(0.0,red_paint,red_scale);
		yellow_paint = mix(0.0,yellow_paint, yellow_scale);
		float ratio = ratio(red_paint, yellow_paint);
		new_ok_hcl.x = ratio*60.0;
	}
	else if(ok_hcl.x < 240.0){
		//YELLOW-BLUE
		float sat = mix(mix(0.0,ok_hcl.y,blue_scale),mix(0.0,ok_hcl.y,yellow_scale),distance(240,ok_hcl.x)/180.0);
		new_ok_hcl.z = mix(ok_hcl.z+lighten_modifier,ok_hcl.z,sat/ok_hcl.y);
		new_ok_hcl.y = sat;
		float yellow_paint = distance(240.0,ok_hcl.x)/180.0;
		float blue_paint = 1.0-yellow_paint;
		yellow_paint = mix(0.0, yellow_paint, yellow_scale);
		blue_paint = mix(0.0, blue_paint, blue_scale);
		float ratio = ratio(yellow_paint, blue_paint);
		new_ok_hcl.x = 60.0+ratio*180.0;
	}
	else{
		//BLUE-RED
		float sat = mix(mix(0.0,ok_hcl.y,red_scale),mix(0.0,ok_hcl.y,blue_scale),1.0-distance(240,ok_hcl.x)/120.0);
		new_ok_hcl.z = mix(ok_hcl.z+lighten_modifier,ok_hcl.z,sat/ok_hcl.y);
		new_ok_hcl.y = sat;
		float red_paint = distance(240.0,ok_hcl.x)/120.0;
		float blue_paint = 1.0-red_paint;
		red_paint = mix(0.0, red_paint, red_scale);
		blue_paint = mix(0.0, blue_paint, blue_scale);
		float ratio = ratio(blue_paint, red_paint);
		new_ok_hcl.x = 240.0+ratio*120.0;
	}
	
	
	vec3 new_ok = vec3(new_ok_hcl.z,new_ok_hcl.y,new_ok_hcl.x);
	COLOR.rgb = oklch_to_rgb(new_ok);
	//COLOR.r = 0.0;
}