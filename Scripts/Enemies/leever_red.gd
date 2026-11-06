class_name LEEVER_RED
extends CharacterBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var ray_cast_up: RayCast2D = $RayCast2D_UP
@onready var ray_cast_down: RayCast2D = $RayCast2D2_DOWN
@onready var ray_cast_left: RayCast2D = $RayCast2D3_LEFT
@onready var ray_cast_right: RayCast2D = $RayCast2D4_RIGHT


@export var SPEED: float = 35.0
@export var MOVE_DURATION: float = 2.0
@export var HIDDEN_DURATION: float = 1.5


var direction: Vector2 = Vector2.ZERO

var move_time: float = 0.0
var hidden_time: float = 0.0

var is_hidden: bool = true


var directions: Array[Vector2] = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT
]


func _ready() -> void:
	hide_leever()


func _physics_process(delta: float) -> void:
	if is_hidden:
		process_hidden(delta)
	else:
		process_movement(delta)


func process_hidden(delta: float) -> void:
	hidden_time += delta

	if hidden_time >= HIDDEN_DURATION:
		show_leever()


func show_leever() -> void:
	is_hidden = false

	hidden_time = 0.0
	move_time = 0.0

	animated_sprite_2d.visible = true
	animated_sprite_2d.play("move")

	change_direction()


func process_movement(delta: float) -> void:
	check_limits()

	move_time += delta

	velocity = direction * SPEED
	move_and_slide()

	if move_time >= MOVE_DURATION:
		hide_leever()


func hide_leever() -> void:
	is_hidden = true

	move_time = 0.0
	hidden_time = 0.0

	velocity = Vector2.ZERO

	animated_sprite_2d.visible = false


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
	print("Vida del Leever: ", health)
	if health <= 0:
		die()

func die() -> void:
	is_dead = true
	set_physics_process(false)
	Global.registrar_limpieza()
	queue_free()
