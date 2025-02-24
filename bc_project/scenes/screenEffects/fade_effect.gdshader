shader_type canvas_item;

uniform float state: hint_range(0.0, 1.0) = 1;
uniform vec2 centering = vec2(0.5,0.5);
uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 pixelColor = texture(TEXTURE,UV);
	vec4 screenColor = texture(screen_texture, SCREEN_UV);
	float distanceFromCenter = length(UV - centering);
	COLOR = mix(screenColor,pixelColor, distanceFromCenter*state*2.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
