shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform int pixel_size = 1;

void fragment() {
	vec2 texture_size = vec2(textureSize(screen_texture, 0)) / float(pixel_size);
	vec2 snapped_uv = floor(SCREEN_UV * texture_size) / texture_size;
	COLOR = textureLod(screen_texture, snapped_uv, 0);
}
