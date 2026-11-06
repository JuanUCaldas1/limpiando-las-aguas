extends Control

signal trivia_terminada

@onready var pregunta_label: Label = $Pregunta
@onready var botones: Array[Button] = [
	$Opciones/Opcion1,
	$Opciones/Opcion2,
	$Opciones/Opcion3
]

var preguntas: Array = [
	{
		"texto": "¿Qué pasa con la basura que arrojamos al agua?",
		"opciones": ["Desaparece sola", "Viaja por los ríos y afecta el ecosistema", "Se convierte en agua limpia"],
		"correcta": 1
	},
	{
		"texto": "¿Qué material tarda más en degradarse en el mar?",
		"opciones": ["Papel", "Plástico", "Hoja de árbol"],
		"correcta": 1
	},
	{
		"texto": "¿Qué ayuda más a proteger los ríos y mares?",
		"opciones": ["Tirar la basura en el río", "Reciclar y no contaminar", "Dejar el agua sucia"],
		"correcta": 1
	}
]

var indice: int = 0
var puntaje: int = 0

func _ready() -> void:
	for i in botones.size():
		botones[i].pressed.connect(_on_opcion_pressed.bind(i))
	mostrar_pregunta()

func mostrar_pregunta() -> void:
	var p: Dictionary = preguntas[indice]
	pregunta_label.text = p["texto"]
	for i in botones.size():
		botones[i].text = p["opciones"][i]

func _on_opcion_pressed(opcion: int) -> void:
	if opcion == preguntas[indice]["correcta"]:
		puntaje += 1
	indice += 1
	if indice < preguntas.size():
		mostrar_pregunta()
	else:
		trivia_terminada.emit()
		Global.puntaje_trivia = puntaje
		get_tree().change_scene_to_file("res://Scenes/World/scene_game.tscn")
