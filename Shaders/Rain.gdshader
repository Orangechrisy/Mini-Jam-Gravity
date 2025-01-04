shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, repeat_disable;
uniform vec3 color: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}
void fragment() {
	COLOR.rgb = color;
	
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
