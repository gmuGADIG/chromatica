shader_type canvas_item;

uniform float speedScale = 10.0;
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

void fragment() {
	COLOR.a = 0.0;
	
	vec2 pos = UV - vec2(0.5,1.0);
	float theta = round(64.0 * atan(pos.y, pos.x));
	float dist = sqrt(pow(pos.x, 2) + pow(pos.y, 2));
	
	float distValue = round(dist * 4.0 + TIME * speedScale + 8.0 * random(vec2(theta)));
	if (dist > clipPosition + random(vec2(theta)) * 0.3 && random(vec2(theta, distValue)) < 0.02) {
		COLOR.a = 1.0;
		COLOR.rgb = hue_to_rgb(random(vec2(theta,0.0)) * 360.0);
	}
}