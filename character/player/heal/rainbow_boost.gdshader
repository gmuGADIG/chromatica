shader_type canvas_item;

//Set via script
uniform float time;
uniform float seed;
uniform float heal_duration;

uniform float speedScale = 3.0;
uniform float clipPosition = 0.2;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

vec3 hue_to_rgb(float hue){
	hue = mod(hue,360.0);
	//hue = 50.0;
	
	float c = 1.0;
	float x = c * (1.0 - abs(
		mod((hue / 60.0),2) - 1.0
	));
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
		rgb.r,
		rgb.g,
		rgb.b
	);
}

vec2 to_polar(vec2 pos){
	float dist = sqrt(pow(pos.x, 2) + pow(pos.y, 2));
	float theta = round(20.0*atan(pos.y, pos.x));
	
	return vec2(theta,dist);
}

void fragment() {
	COLOR.a = 0.0;
	
	vec2 pos = UV - vec2(0.5,0.5);
	vec2 polar = to_polar(pos);
	float theta = polar.x;
	float dist = polar.y;
	
	float distValue = 1000.0 * seed + round(20.0 * dist + time * speedScale * (2.0 + 8.0 * random(vec2(theta))));
	float thresh = random(vec2(theta, distValue));
	float r = 0.5;
	
	bool after_startup = time+dist > r;
	bool before_end = time+dist-0.1 < heal_duration;
	if (thresh < 0.02 && dist < r && after_startup && before_end) {
		COLOR.a = 1.0;
		COLOR.rgb = hue_to_rgb(random(vec2(theta,seed)) * 360.0);
	}
}