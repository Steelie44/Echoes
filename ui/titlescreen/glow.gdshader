shader_type canvas_item;

uniform vec4 color_tint : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 glow_color : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float glow_strength : hint_range(0.0, 10.0) = 2.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 final_color = tex * color_tint;
	final_color.rgb += glow_color.rgb * glow_strength * tex.a;
	COLOR = final_color;
}