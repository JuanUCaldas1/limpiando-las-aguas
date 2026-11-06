class_name FV_deathExpand_scene
extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
#Timer darle un tiempo de vida y luego destruirlo creando una señal
@onready var timer_destroid: Timer = $TimerDestroid

@export var speed := 80.0

var direction := Vector2.ZERO

func _ready() -> void:
	animated_sprite_2d.play("default")
	timer_destroid.start()

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

func _on_timer_destroid_timeout() -> void:
	queue_free()
