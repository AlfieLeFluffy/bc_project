shader_type canvas_item;

uniform sampler2D screenTexture: hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 color = texture(TEXTURE,UV);
	vec4 screenColor = texture(screenTexture, SCREEN_UV);
	vec4 inverseColor = vec4(1.0 - screenColor.rgb, color.a);
	COLOR = inverseColor;
}