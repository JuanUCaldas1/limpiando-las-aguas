extends Control

@onready var boton_jugar: Button = $VBoxContainer/BotonJugar
@onready var boton_instrucciones: Button = $VBoxContainer/BotonInstrucciones

func _ready() -> void:
	boton_jugar.grab_focus()
	boton_jugar.pressed.connect(_on_jugar_pressed)
	boton_instrucciones.pressed.connect(_on_instrucciones_pressed)

func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/trivia.tscn")

func _on_instrucciones_pressed() -> void:
	pass # Pantalla de instrucciones, la hacemos después
