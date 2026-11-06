extends TileMapLayer

func _ready() -> void:
	actualizar_contaminacion(1.0)

func actualizar_contaminacion(valor: float) -> void:
	material.set_shader_parameter("contaminacion", clamp(valor, 0.0, 1.0))
