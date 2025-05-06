shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0);
uniform float line_thickness : hint_range(0, 10) = 0.0;

uniform int row = -1;
uniform sampler2D base: source_color;
uniform sampler2D recolor: source_color;

const vec2 OFFSETS[8] = {
	vec2(-1, -1), vec2(-1, 0), vec2(-1, 1), vec2(0, -1), vec2(0, 1),
	vec2(1, -1), vec2(1, 0), vec2(1, 1)
};

int get_position(vec4 color) {
	ivec2 size = textureSize(base,0);
	for (int i = 0; i < size.x; i++){
		if (color == texelFetch(base,ivec2(i,0),0) ){
			return i;
		}
	}
	return -1;
}

void fragment() {

	vec4 color = texture(TEXTURE, UV);
	ivec2 recolorSize = textureSize(recolor,0);

	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
	float outline = 0.0;

	for (int i = 0; i < OFFSETS.length(); i++) {
		outline += texture(TEXTURE, UV + size * OFFSETS[i]).a;
	}
	outline = min(outline, 1.0);

	if (outline > 0.0){
		COLOR = mix(color, line_color, outline - color.a);
	}
	else if (row < 0 || recolorSize.y <= row){
		COLOR = color;
	}
	else{
		int index = get_position(color);
		if (index < 0){
			COLOR = color;
		}
		else{
			ivec2 position = ivec2(index,row);
			vec4 output = texelFetch(recolor, position,0);
			COLOR= output;
		}
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
