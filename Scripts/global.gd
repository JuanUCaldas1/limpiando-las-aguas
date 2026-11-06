extends Node

signal limpieza_cambiada(valor: int)
signal zona_limpia

const META_LIMPIEZA: int = 20
var basura_recogida: int = 0
var total_basura: int = 0
var puntaje_trivia: int = 0
var puntaje_final: int = 0
var fase_final: bool = false
var mostrar_pantalla_final: bool = false

func registrar_total() -> void:
	total_basura = get_tree().get_nodes_in_group("ENEMIES").size()
	print("Total de enemigos: ", total_basura)

func registrar_limpieza() -> void:
	basura_recogida += 1
	var progreso: float = float(basura_recogida) / float(max(total_basura, 1))
	limpieza_cambiada.emit(basura_recogida)
	get_tree().call_group("AGUA", "actualizar_contaminacion", 1.0 - progreso)
	if basura_recogida >= total_basura:
		zona_limpia.emit()
