class_name STALFOS
extends CharacterBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var ray_cast_up: RayCast2D = $RayCast2D_UP
@onready var ray_cast_down: RayCast2D = $RayCast2D2_DOWN
@onready var ray_cast_left: RayCast2D = $RayCast2D3_LEFT
@onready var ray_cast_right: RayCast2D = $RayCast2D4_RIGHT


@export var SPEED: float = 40.0


var direction: Vector2 = Vector2.ZERO


var directions: Array[Vector2] = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT
]


func _ready() -> void:
	change_direction()
	animated_sprite_2d.play("walk")


func _physics_process(_delta: float) -> void:
	check_limits()

	velocity = direction * SPEED
	move_and_slide()


func check_limits() -> void:
	if direction == Vector2.UP and ray_cast_up.is_colliding():
		change_direction()

	elif direction == Vector2.DOWN and ray_cast_down.is_colliding():
		change_direction()

	elif direction == Vector2.LEFT and ray_cast_left.is_colliding():
		change_direction()

	elif direction == Vector2.RIGHT and ray_cast_right.is_colliding():
		change_direction()


func change_direction() -> void:
	var available_directions: Array[Vector2] = []

	if not ray_cast_up.is_colliding():
		available_directions.append(Vector2.UP)

	if not ray_cast_down.is_colliding():
		available_directions.append(Vector2.DOWN)

	if not ray_cast_left.is_colliding():
		available_directions.append(Vector2.LEFT)

	if not ray_cast_right.is_colliding():
		available_directions.append(Vector2.RIGHT)

	if not available_directions.is_empty():
		direction = available_directions.pick_random()
		
		
		
var health: int = 1
var is_dead: bool = false

func take_damage() -> void:
	if is_dead:
		return
	health -= 1
	print("Vida del Stalfos: ", health)
	if health <= 0:
		die()

func die() -> void:
	is_dead = true
	set_physics_process(false)
	Global.registrar_limpieza()
	queue_free()
