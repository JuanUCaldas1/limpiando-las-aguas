class_name Screen_Transition 
extends Node2D

@onready var camera_2d: Camera2D = $".."
@onready var player: FV_player = $"../../FV_player"
@onready var area_2d_up: Area2D = $Area2D_UP
@onready var area_2d_down: Area2D = $Area2D_DOWN
@onready var area_2d_left: Area2D = $Area2D_LEFT
@onready var area_2d_4_right: Area2D = $Area2D4_RIGHT
var move_camara: bool = false

func _on_area_2d_up_body_entered(body: Node2D) -> void:
	if body.name == "FV_player" and not move_camara:
		move_camara = true
		
		await player.move_screen_transition_player(Vector2.UP, 20)
		
		var new_position_camera = camera_2d.position + Vector2(0,-176)
		
		var tween = create_tween()
		tween.tween_property(camera_2d,"position", new_position_camera, 0.8)
		await tween.finished
		
		player.can_move = true
		move_camara = false
		
		print ("ha finalizado transicion superior")

func _on_area_2d_down_body_entered(body: Node2D) -> void:
	if body.name == "FV_player" and not move_camara:
		move_camara = true
		
		await player.move_screen_transition_player(Vector2.DOWN, 20)
		
		var new_position_camera = camera_2d.position + Vector2(0,176)
		
		var tween = create_tween()
		tween.tween_property(camera_2d,"position", new_position_camera, 0.8)
		await tween.finished
		
		
		
		player.can_move = true
		move_camara = false
		
		print ("ha finalizado transicion inferior")


func _on_area_2d_left_body_entered(body: Node2D) -> void:
	if body.name == "FV_player" and not move_camara:
		move_camara = true
		
		await player.move_screen_transition_player(Vector2.LEFT, 20)
		
		var new_position_camera = camera_2d.position + Vector2(-256,0)
		
		var tween = create_tween()
		tween.tween_property(camera_2d,"position", new_position_camera, 0.8)
		await tween.finished
		
		
		
		player.can_move = true
		move_camara = false
		
		print ("ha finalizado transicion izquierda")


func _on_area_2d_4_right_body_entered(body: Node2D) -> void:
	if body.name == "FV_player" and not move_camara:
		move_camara = true
		
		await player.move_screen_transition_player(Vector2.RIGHT, 20)
		
		var new_position_camera = camera_2d.position + Vector2(256,0)
		
		var tween = create_tween()
		tween.tween_property(camera_2d,"position", new_position_camera, 0.8)
		await tween.finished
		
		
		
		player.can_move = true
		move_camara = false
		
		print ("ha finalizado transicion derecha")
