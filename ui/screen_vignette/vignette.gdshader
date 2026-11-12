// THIS SHADER IS MADE BY TTien63 (aka. _she from the afterlife)
// Goodluck painting your game :3
// Instagram: _shefromtheafterlife
// YouTube, Spotify Artist, etc: TTien63

shader_type canvas_item;

uniform float min_inner_radius = 0.7;
uniform float inner_radius_bounce = 0.2;

uniform float min_outer_radius = 1.3;
uniform float outer_radius_bounce = 0.1;

uniform float bounce_frequency = 1.2;

uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;

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

void fragment() {
	vec2 uv = SCREEN_UV;
	// ---- Mix result with original based on freeze ----
	vec3 og_rgb = texture(screen_tex, uv).rgb;
	vec3 hsl = rgb_to_hsl(og_rgb);
	
	float inner_radius = min_inner_radius+abs(inner_radius_bounce*sin(bounce_frequency*TIME));
	float outer_radius = min_outer_radius+abs(outer_radius_bounce*sin(bounce_frequency*TIME));
	//float inner_radius = 0.0;
	//Figure out saturation value
	float x = abs(UV.x-.5)*2.0;
	float y = abs(UV.y-.5)*2.0;
	float q = (1.0-sqrt(x*x+y*y)/outer_radius)/(1.0-inner_radius);
	q = clamp(q,0.0,1.0);
	if(hsl.y >= 0.0){
		hsl.y = mix(0.0,hsl.y,q);
	}
	else{
		hsl.xyz = vec3(1.0,1.0,1.0);
	}
	
	
	vec3 result = hsl_to_rgb(hsl);

	COLOR.rgb = result;
}
