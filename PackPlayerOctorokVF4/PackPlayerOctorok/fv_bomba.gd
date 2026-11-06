class_name FV_bomba_scene
extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_item: AudioStreamPlayer2D = $AudioItem
@export var tiempo_explosion := 3.0
@export var radio_explosion := 100

func _ready():
	$Timer.wait_time = tiempo_explosion
	$Timer.start()

func _on_timer_timeout():
	explotar()

func explotar():
	$Sprite2D.hide()
	$CollisionShape2D.disabled = true
	$AudioItem.play()
	await $AudioItem.finished
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "FV_player":
		print("Bomba Recolectada")
		audio_item.play()
		sprite_2d.visible = false
		audio_item.finished.connect(queue_free)
