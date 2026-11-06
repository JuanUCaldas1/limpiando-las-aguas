class_name FV_rupia_scene
extends Area2D

@onready var audio_item_rupie: AudioStreamPlayer2D = $AudioItemRupie

@onready var sprite_2d: Sprite2D = $Sprite2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "FV_player":
		print("Rupia recolectada!!")
		audio_item_rupie.play()
		sprite_2d.visible = false
		audio_item_rupie.finished.connect(queue_free)
		
