shader_type canvas_item;

uniform float value: hint_range(0.0, 1.0, 0.01);

void fragment() {
	vec4 color = texture(TEXTURE,UV);
	if (color.a == 0.0){
		color.a = 0.0;
		COLOR = color;
	}
	else{
		color.a = value;
		COLOR = color;
	}
}
