shader_type canvas_item;

uniform vec3 pulse_color : source_color = vec3(0.2, 1.0, 0.2);

uniform float pulse_speed : hint_range(0.0, 10.0, 0.1) = 4.0;

uniform float min_brightness : hint_range(0.0, 2.0, 0.05) = 0.5;

uniform float pulse_strength : hint_range(0.0, 3.0, 0.05) = 1.5;


void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;

    COLOR = vec4(
        tex.rgb
        * pulse_color
        * (min_brightness + pulse * pulse_strength),
        tex.a
    );
}