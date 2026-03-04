shader_type canvas_item;

uniform float glow_size = 12.0;
uniform vec4 glow_color : source_color = vec4(0.2, 0.9, 1.0, 1.0);
uniform float glow_strength = 0.0;

void fragment() {

	vec4 tex = texture(TEXTURE, UV);

	float glow = 0.0;

	for (float x = -glow_size; x <= glow_size; x++) {
		for (float y = -glow_size; y <= glow_size; y++) {

			vec2 offset = vec2(x, y) * TEXTURE_PIXEL_SIZE;
			float sample_alpha = texture(TEXTURE, UV + offset).a;

			float dist = length(vec2(x, y));
			float falloff = 1.0 - (dist / glow_size);

			glow += sample_alpha * max(falloff, 0.0);
		}
	}

	glow = clamp(glow, 0.0, 1.0);

	vec4 glow_col = glow_color;
	glow_col.a = glow * glow_strength;

	// 🔥 Nur außerhalb der Original Alpha zeichnen
	float outside = step(tex.a, 0.01);

	COLOR = tex + glow_col * outside;
}