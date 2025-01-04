shader_type canvas_item;

uniform vec4 replace_color : source_color;

void fragment() {
	vec4 pixel_color = texture(TEXTURE, UV);
	if (pixel_color == vec4(1, 1, 1, 1)) {
		//pixel_color = replace_color;
		COLOR = replace_color;
	}
}
