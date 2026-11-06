class_name FV_Heart_scene
extends Area2D

@onready var audio_item_get: AudioStreamPlayer2D = $AudioItemGet
@onready var sprite_2d: Sprite2D = $Sprite2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "FV_player":
		print("Aumenta la vida del Player")
		
		audio_item_get.play()
		sprite_2d.visible = false
		audio_item_get.finished.connect(queue_free)
		
