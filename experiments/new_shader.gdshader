shader_type canvas_item;
render_mode blend_mix;

// Varyings
varying vec2 position;
uniform float modulate = 1.0;
uniform float scale = 1.0;
uniform float speed = 1.0;

void vertex() {
	position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	float gradient = (1.0 - UV.y);
	vec2 offset = vec2(
		( // x
			sin(TIME*speed/0.3 + position.x/80.0 ) + 
			sin(TIME*speed/0.5 + position.x/40.0 ) + 
			sin(TIME*speed/0.2 + position.x/80.0 )
		)/3.0,
		( // y
			cos(TIME*speed/0.4 + position.x/90.0 ) + 
			sin(TIME*speed/0.5 + position.x/80.0 ) + 
			cos(TIME*speed/0.6 + position.x/80.0 )
		)/4.0
	) * scale;
	float col = (1.0 +
		((sin(position.x/80.0) + sin(position.x/40.0) + sin(position.x/80.0)) / 3.0)
		) / 2.0;
	vec2 uv = mix(UV, UV + (offset * vec2(0.1, 0.05)), gradient);
	vec4 tex = texture(TEXTURE, uv);
	tex.rgb = mix(tex.rgb, mix(tex.rgb, vec3(0.6,0.7,0),0.5) , col);
	
	tex.rgb *= modulate;
	tex.rgb = mix(tex.rgb, vec3(0.0) , -gradient);
	COLOR = tex;
}