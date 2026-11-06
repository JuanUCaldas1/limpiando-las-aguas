extends CanvasLayer

@onready var boton_reintentar: Button = $BotonReintentar
@onready var puntaje_label: Label = $Puntaje

func _ready() -> void:
	visible = false
	boton_reintentar.pressed.connect(_on_reintentar_pressed)
	Global.zona_limpia.connect(mostrar)

func mostrar() -> void:
	puntaje_label.text = "Trivia inicial: %d de 3 correctas" % Global.puntaje_trivia
	visible = true
	get_tree().paused = true

func _on_reintentar_pressed() -> void:
	get_tree().paused = false
	Global.basura_recogida = 0
	get_tree().change_scene_to_file("res://Scenes/menu_inicio.tscn")
