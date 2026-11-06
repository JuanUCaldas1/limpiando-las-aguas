extends CanvasLayer

@onready var barra_limpieza: ProgressBar = $BarraLimpieza

func _ready() -> void:
	Global.registrar_total()
	barra_limpieza.min_value = 0
	barra_limpieza.max_value = Global.total_basura
	barra_limpieza.value = Global.basura_recogida
	Global.limpieza_cambiada.connect(_on_limpieza_cambiada)

func _on_limpieza_cambiada(valor: int) -> void:
	barra_limpieza.value = valor
