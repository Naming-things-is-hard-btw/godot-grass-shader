shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture;
uniform float amount = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

float noise(vec2 p) {
	return ((
		(
			sin(p.y / 10.0)+
			sin(p.y / 20.0)+
			sin(p.y / 50.0)+
			sin(p.y / 5.0)+
			sin(p.y / 10.0)
		) / 5.0
	) + 1.0)/2.0;
}


float circle(vec2 p, vec2 c) {
	vec2 dir = p - c;

	return ceil((1.0 - sqrt((dir.x*dir.x)+(dir.y*dir.y)))*10.0 ) / 10.0;
}

void fragment() {
	float r = (
		noise((SCREEN_UV * 100.0) - TIME * 1000.0) *
		noise((SCREEN_UV * 100.0) - TIME * 1000.0) *
		noise((SCREEN_UV * 100.0) + TIME * 700.0)
	);

	r = floor(r*2.0) / 2.0;

	COLOR.r = textureLod(screen_tex, SCREEN_UV + vec2(r * 0.1,r * 0.01) + vec2(0.01, 0), 0).r;
	COLOR.g = textureLod(screen_tex, SCREEN_UV + vec2(r * 0.08,r * 0.08) + vec2(0.0, 0.01), 0).g;
	COLOR.b = textureLod(screen_tex, SCREEN_UV + vec2(r * 0.05,r * 0.01) + vec2(-0.01, -0.01), 0).b;

	//COLOR.r = r;
	float a = floor(((noise(vec2(TIME*20.0))+0.2) * 10.0)*3.0)/3.0;
	//COLOR.rgb = floor(COLOR.rgb * amount) / amount;
	COLOR.rgb = floor(COLOR.rgb * a) / a;
	//COLOR.g = r;
	//COLOR.b = b;
	COLOR = mix(COLOR, texture(screen_tex,SCREEN_UV), amount);
}

