extends Node

signal limpieza_cambiada(valor: int)
signal zona_limpia

const META_LIMPIEZA: int = 20
var basura_recogida: int = 0
var total_basura: int = 0
var puntaje_trivia: int = 0

func registrar_total() -> void:
	total_basura = get_tree().get_nodes_in_group("ENEMIES").size()
	print("Total de enemigos: ", total_basura)
func registrar_limpieza() -> void:
	basura_recogida += 1
	limpieza_cambiada.emit(basura_recogida)
	if basura_recogida >= total_basura:
		zona_limpia.emit()
