shader_type canvas_item;

uniform float lighten_modifier : hint_range(0.0,1.0,0.01) = 0.0;

uniform float red_scale : hint_range(0.0, 1.0, 0.1);
uniform float yellow_scale : hint_range(0.0, 1.0, 0.1);
uniform float blue_scale : hint_range(0.0, 1.0, 0.1);
//const vec3 grey_scale = vec3(0.2,0.2,0.2);

vec3 rgb_to_hsl(vec3 color){
	float color_max = max(max(color.r,color.g),color.b);
	float color_min = min(min(color.r,color.g),color.b);
	float delta = color_max - color_min;
	
	float hue;
	float saturation;
	float lightness;
	
	lightness = (color_max + color_min)/2.0;
	if(delta == 0.0){
		hue = 0.;
		saturation = 0.;
	}
	else{
		saturation = delta/(1.0 - abs(2.0*lightness-1.0));
		
		if(color_max == color.r){
			hue = 60.0 * mod((color.g-color.b)/delta,6);
		}
		else if(color_max == color.g){
			hue = 60.0 * ((color.b-color.r)/delta + 2.0);
		}
		else if(color_max == color.b){
			hue = 60.0 * ((color.r-color.g)/delta + 4.0);
		}
		else{
			return vec3(1.0,1.0,1.0);
		}
	}
	return vec3(hue,saturation,lightness);
}

vec3 hsl_to_rgb(vec3 hsl){
	float hue = mod(hsl.x,360.0);
	float saturation = hsl.y;
	float lightness = hsl.z;
	
	float c = (1.0 - abs(2.0*lightness-1.0)) * saturation;
	float x = c * (1.0 - abs(
		mod((hue / 60.0),2) - 1.0
	));
	float m = lightness - 0.5*c;
	
	vec3 rgb;
	if(hue < 60.0){
		rgb = vec3(c,x,0.0);
	}
	else if(hue < 120.0){
		rgb = vec3(x,c,0.0);
	}
	else if(hue < 180.0){
		rgb = vec3(0.0,c,x);
	}
	else if(hue < 240.0){
		rgb = vec3(0.0,x,c);
	}
	else if(hue < 300.0){
		rgb = vec3(x,0.0,c);
	}
	else if(hue < 360.0){
		rgb = vec3(c,0.0,x);
	}
	else{
		return vec3(1.0,1.0,1.0);
	}
	return vec3(
		rgb.r+m,
		rgb.g+m,
		rgb.b+m
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
	vec3 hsl = rgb_to_hsl(COLOR.rgb);
	
	
	//vec3 hsl = rgb_to_hsl(COLOR.rgb);
	vec3 new_hsl = hsl;
	new_hsl.y = 0.0;
	
	
	if(hsl.x < 60.0){
		//RED-YELLOw
		float sat = mix(mix(0.0,hsl.y,red_scale),mix(0.0,hsl.y,yellow_scale),distance(0.0,hsl.x)/60.0);
		new_hsl.z = mix(hsl.z+lighten_modifier,hsl.z,sat/hsl.y);
		new_hsl.y = sat;
		float red_paint = distance(60.0,hsl.x)/60.0;
		float yellow_paint = 1.0-red_paint;
		red_paint = mix(0.0,red_paint,red_scale);
		yellow_paint = mix(0.0,yellow_paint, yellow_scale);
		float ratio = ratio(red_paint, yellow_paint);
		new_hsl.x = ratio*60.0;
	}
	else if(hsl.x < 240.0){
		//YELLOW-BLUE
		float sat = mix(mix(0.0,hsl.y,blue_scale),mix(0.0,hsl.y,yellow_scale),distance(240,hsl.x)/180.0);
		new_hsl.z = mix(hsl.z+lighten_modifier,hsl.z,sat/hsl.y);
		new_hsl.y = sat;
		float yellow_paint = distance(240.0,hsl.x)/180.0;
		float blue_paint = 1.0-yellow_paint;
		yellow_paint = mix(0.0, yellow_paint, yellow_scale);
		blue_paint = mix(0.0, blue_paint, blue_scale);
		float ratio = ratio(yellow_paint, blue_paint);
		new_hsl.x = 60.0+ratio*180.0;
	}
	else{
		//BLUE-RED
		float sat = mix(mix(0.0,hsl.y,red_scale),mix(0.0,hsl.y,blue_scale),1.0-distance(240,hsl.x)/120.0);
		new_hsl.z = mix(hsl.z+lighten_modifier,hsl.z,sat/hsl.y);
		new_hsl.y = sat;
		float red_paint = distance(240.0,hsl.x)/120.0;
		float blue_paint = 1.0-red_paint;
		red_paint = mix(0.0, red_paint, red_scale);
		blue_paint = mix(0.0, blue_paint, blue_scale);
		float ratio = ratio(blue_paint, red_paint);
		new_hsl.x = 240.0+ratio*120.0;
	}
	
	COLOR.rgb = hsl_to_rgb(new_hsl);
}