extends Control

signal trivia_terminada

@onready var pregunta_label: Label = $Pregunta
@onready var botones: Array[Button] = [
	$Opciones/Opcion1,
	$Opciones/Opcion2,
	$Opciones/Opcion3
]

var es_final: bool = false

var preguntas_inicial: Array = [
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

var preguntas_final: Array = [
	{
		"texto": "¿Qué animal marino suele confundir una bolsa plástica con alimento?",
		"opciones": ["La tortuga marina", "El delfín", "El pulpo"],
		"correcta": 0
	},
	{
		"texto": "¿Qué es el microplástico?",
		"opciones": ["Plástico menor a 5 milímetros", "Un tipo de pez", "Una botella reciclada"],
		"correcta": 0
	},
	{
		"texto": "¿Cuál es la mejor acción después de usar una botella?",
		"opciones": ["Lanzarla al río", "Reciclarla en el contenedor adecuado", "Enterrarla en la orilla"],
		"correcta": 1
	}
]

var preguntas: Array = []
var indice: int = 0
var puntaje: int = 0


func _ready() -> void:
	for i in botones.size():
		botones[i].pressed.connect(_on_opcion_pressed.bind(i))
	es_final = Global.fase_final
	preguntas = preguntas_final if es_final else preguntas_inicial
	mostrar_pregunta()


func mostrar_pregunta() -> void:
	var p: Dictionary = preguntas[indice]
	pregunta_label.text = p["texto"]
	for i in botones.size():
		botones[i].text = p["opciones"][i]


func _on_opcion_pressed(opcion: int) -> void:
	if indice >= preguntas.size():
		return
	if opcion == preguntas[indice]["correcta"]:
		puntaje += 1
	indice += 1
	if indice < preguntas.size():
		mostrar_pregunta()
	else:
		if es_final:
			Global.mostrar_pantalla_final = true
			Global.puntaje_final = puntaje
			Global.fase_final = false
			get_tree().change_scene_to_file("res://Scenes/UI/pantalla_final.tscn")
		else:
			Global.puntaje_trivia = puntaje
			get_tree().change_scene_to_file("res://Scenes/World/scene_game.tscn")
