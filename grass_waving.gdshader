shader_type canvas_item;

uniform float time_scale = 1.0;
uniform float scale = 1.0;
uniform float modulate = 1.0;

varying vec2 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX,1.0,1.0)).xy;
}

void fragment() {
	float gradient = 1.0 - UV.y;
	float time = TIME * time_scale;
	vec2 position = world_position * scale;
	vec2 offset = vec2
	(
		// x axis
		(
			sin((time * 2.4) + (position.x/80.0)) +
			sin((time * 0.9) + (position.x/40.0)) +
			sin((time * 4.0) + (position.x/60.0)) +
			sin((time * 1.9) + (position.x/30.0)) +
			sin((time * 1.6) + (position.x/80.0))
		) / 5.0,
		// y axis
		(
			cos((time * 2.4) + (position.x/80.0)) +
			sin((time * 0.9) + (position.x/40.0)) +
			cos((time * 4.0) + (position.x/90.0)) +
			sin((time * 1.9) + (position.x/60.0)) +
			cos((time * 1.6) + (position.x/90.0))
		) / 5.0
	);
	float col =
	(
		sin(((position.x+160.0)/50.0)) +
		sin(((position.x+3600.0)/150.0)) +
		sin(((position.x+100.0)/200.0)) +
		sin(((position.x+10.0)/100.0)) +
		sin(((position.x+1600.0)/10.0)) +
		sin(((position.x+170.0)/150.0)) +
		sin((position.x/10.0)) +
		sin((position.x/70.0))
	);
	col += 1.0;
	col /= 2.0 * 8.0;
	offset *= vec2(0.2, 0.05) * scale;
	COLOR = texture(TEXTURE, mix(UV, UV + offset, gradient));
	COLOR.rgb *= modulate;
	COLOR.rgb = mix(
		COLOR.rgb,
		mix(COLOR.rgb, vec3(1.0,1.0,0.0), 0.7),
		col);
}
