// https://github.com/godotengine/godot-demo-projects/blob/master/2d/sprite_shaders/shaders/blur.gdshader
//
//shader_type canvas_item;
//render_mode blend_mix;
//
//uniform float radius = 4.0;
//
//void fragment() {
//	vec4 col = texture(TEXTURE, UV);
//	vec2 ps = TEXTURE_PIXEL_SIZE;
//
//	col += texture(TEXTURE, UV + vec2(0.0, -radius) * ps);
//	col += texture(TEXTURE, UV + vec2(0.0, radius) * ps);
//	col += texture(TEXTURE, UV + vec2(-radius, 0.0) * ps);
//	col += texture(TEXTURE, UV + vec2(radius, 0.0) * ps);
//	col /= 5.0;
//
//	COLOR = col;
//}

shader_type canvas_item;

uniform float blur_amount : hint_range(0, 5);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
}