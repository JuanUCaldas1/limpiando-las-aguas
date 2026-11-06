extends CanvasLayer

@onready var boton_reintentar: Button = $BotonReintentar
@onready var puntaje_label: Label = $Puntaje
@onready var boton_trivia_final: Button = $BotonTriviaFinal


func _ready() -> void:
	boton_reintentar.pressed.connect(_on_reintentar_pressed)
	boton_trivia_final.pressed.connect(_on_trivia_final_pressed)
	Global.zona_limpia.connect(mostrar)

	if Global.mostrar_pantalla_final:
		Global.mostrar_pantalla_final = false
		mostrar()
	else:
		visible = false


func mostrar() -> void:
	print("PANTALLA FINAL MOSTRADA")
	puntaje_label.text = "Trivia inicial: %d de 3 correctas" % Global.puntaje_trivia
	visible = true
	get_tree().paused = true


func _on_trivia_final_pressed() -> void:
	get_tree().paused = false
	Global.fase_final = true
	get_tree().change_scene_to_file("res://Scenes/trivia.tscn")


func _on_reintentar_pressed() -> void:
	get_tree().paused = false
	Global.basura_recogida = 0
	get_tree().change_scene_to_file("res://Scenes/menu_inicio.tscn")
