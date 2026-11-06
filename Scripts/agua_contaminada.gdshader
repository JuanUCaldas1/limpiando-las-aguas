shader_type canvas_item;

uniform float contaminacion : hint_range(0.0, 1.0) = 0.0;
uniform vec4 color_sucio : source_color = vec4(0.35, 0.3, 0.12, 1.0);

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	// Detecta píxeles azules (agua): el azul domina sobre rojo y verde
	float es_agua = step(0.1, base.b - max(base.r, base.g));
	vec3 sucio = mix(base.rgb, color_sucio.rgb, contaminacion);
	COLOR = vec4(mix(base.rgb, sucio, es_agua), base.a);
}