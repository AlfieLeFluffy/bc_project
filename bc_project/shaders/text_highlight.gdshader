shader_type canvas_item;

uniform float ratio: hint_range(0.0, 1.0, 0.1) = 0.8;
uniform float offset: hint_range(0.0, 1.0, 0.1) = 0.2;
uniform sampler2D screenTexture: hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 color = texture(TEXTURE,UV);
	vec4 screenColor = texture(screenTexture, SCREEN_UV);
	vec4 invertedColor = vec4(1.0 - screenColor.rgb - offset, color.a);
	vec4 outputColor = mix(color, invertedColor, ratio);
	COLOR = outputColor;
}