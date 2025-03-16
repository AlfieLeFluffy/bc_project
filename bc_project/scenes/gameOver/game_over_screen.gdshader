shader_type canvas_item;

uniform vec4 color: source_color;
uniform sampler2D genTexture;
uniform sampler2D screenTexture: hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 textureColor = texture(TEXTURE,UV);
	vec4 noiseColor = texture(genTexture,UV);
	vec3 mixColor = vec3(noiseColor.r * color.r /2.0,noiseColor.g * color.g/2.0,noiseColor.b * color.b/2.0);
	COLOR = vec4(mixColor.r,mixColor.g,mixColor.b,textureColor.a*((noiseColor.r+noiseColor.g+noiseColor.b)/3.0));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
