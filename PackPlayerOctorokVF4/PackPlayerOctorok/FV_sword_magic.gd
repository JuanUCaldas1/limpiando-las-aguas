class_name FV_swordMagic_scene
extends Area2D

@export var SPEED: float = 100.0

var direction: Vector2 = Vector2.RIGHT

#Aplicamos movimiento a la espada
func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

#Verificamos si esta en el grupo de enemigos
func _on_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()
	
	if enemy != null and enemy.is_in_group("ENEMIES"):
		enemy.take_damage()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("----ESPADA DESTRUIDA---")
	queue_free()
