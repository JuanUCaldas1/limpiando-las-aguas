class_name TEKTITE_BLUE
extends CharacterBody2D

# Configuración de movimiento
@export var SPEED: float = 45.0
@export var JUMP_HEIGHT: float = 8.0
@export var JUMP_DURATION: float = 0.7
@export var PAUSE_DURATION: float = 0.4

# Efectos visuales
@export var death_expand_scene: PackedScene
@export var death_effect_scene: PackedScene

# Items
@export var rupie_scene: PackedScene
@export var heart_scene: PackedScene
@export var bomba_scene: PackedScene

# Referencias a Nodos
@onready var audio_explosion: AudioStreamPlayer2D = $audio_explosion
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var ray_cast_up_left: RayCast2D = $RayCast2D_UP_LEFT
@onready var ray_cast_up_right: RayCast2D = $RayCast2D2_UP_RIGHT
@onready var ray_cast_down_left: RayCast2D = $RayCast2D3_DOWN_LEFT
@onready var ray_cast_down_right: RayCast2D = $RayCast2D4_DOWN_RIGHT

# Variables de estado
var health: int = 1
var is_dead: bool = false

var direction: Vector2 = Vector2.ZERO
var jump_time: float = 0.0
var pause_time: float = 0.0
var is_jumping: bool = false


func _ready() -> void:
	change_direction()
	start_jump()


func _physics_process(delta: float) -> void:
	if is_jumping:
		process_jump(delta)
	else:
		process_pause(delta)


# Recibir daño
func take_damage() -> void:
	if is_dead:
		return
	
	health -= 1
	print("Vida del Tektite: ", health)

	if health <= 0:
		die()


# Lógica de salto
func start_jump() -> void:
	jump_time = 0.0
	is_jumping = true
	animated_sprite_2d.play("jump")


func process_jump(delta: float) -> void:
	check_limits()

	jump_time += delta
	var progress: float = jump_time / JUMP_DURATION

	animated_sprite_2d.position.y = -sin(progress * PI) * JUMP_HEIGHT

	velocity = direction * SPEED
	move_and_slide()

	if jump_time >= JUMP_DURATION:
		finish_jump()


func finish_jump() -> void:
	is_jumping = false
	jump_time = 0.0
	pause_time = 0.0
	velocity = Vector2.ZERO
	animated_sprite_2d.position.y = 0.0


func process_pause(delta: float) -> void:
	pause_time += delta

	if pause_time >= PAUSE_DURATION:
		change_direction()
		start_jump()


func check_limits() -> void:
	if direction.x < 0 and direction.y < 0 and ray_cast_up_left.is_colliding():
		change_direction()
	elif direction.x > 0 and direction.y < 0 and ray_cast_up_right.is_colliding():
		change_direction()
	elif direction.x < 0 and direction.y > 0 and ray_cast_down_left.is_colliding():
		change_direction()
	elif direction.x > 0 and direction.y > 0 and ray_cast_down_right.is_colliding():
		change_direction()


func change_direction() -> void:
	var available_directions: Array[Vector2] = []

	if not ray_cast_up_left.is_colliding():
		available_directions.append(Vector2(-1, -1).normalized())

	if not ray_cast_up_right.is_colliding():
		available_directions.append(Vector2(1, -1).normalized())

	if not ray_cast_down_left.is_colliding():
		available_directions.append(Vector2(-1, 1).normalized())

	if not ray_cast_down_right.is_colliding():
		available_directions.append(Vector2(1, 1).normalized())

	if not available_directions.is_empty():
		direction = available_directions.pick_random()


# Soltar objeto aleatorio
func drop_random_item() -> void:
	var random_number: int = randi_range(1, 100)
	var item_scene: PackedScene = null
	
	if random_number <= 20:
		item_scene = bomba_scene
	elif random_number <= 30:
		item_scene = rupie_scene
	elif random_number <= 50:
		item_scene = heart_scene
	else:
		item_scene = null
	
	if item_scene != null:
		var item = item_scene.instantiate()
		item.global_position = global_position
		get_parent().call_deferred("add_child", item)


# Función de muerte
func die() -> void:
	is_dead = true

	set_physics_process(false)

	# Diagonal arriba-izquierda ↖
	var effect_up_left = death_expand_scene.instantiate()
	effect_up_left.global_position = global_position
	effect_up_left.direction = Vector2(-1, -1)
	effect_up_left.get_node("AnimatedSprite2D").scale = Vector2(1, 1)
	get_parent().call_deferred("add_child", effect_up_left)

	# Diagonal arriba-derecha ↗
	var effect_up_right = death_expand_scene.instantiate()
	effect_up_right.global_position = global_position
	effect_up_right.direction = Vector2(1, -1)
	effect_up_right.get_node("AnimatedSprite2D").scale = Vector2(-1, 1)
	get_parent().call_deferred("add_child", effect_up_right)

	# Diagonal abajo-izquierda ↙
	var effect_down_left = death_expand_scene.instantiate()
	effect_down_left.global_position = global_position
	effect_down_left.direction = Vector2(-1, 1)
	effect_down_left.get_node("AnimatedSprite2D").scale = Vector2(1, -1)
	get_parent().call_deferred("add_child", effect_down_left)

	# Diagonal abajo-derecha ↘
	var effect_down_right = death_expand_scene.instantiate()
	effect_down_right.global_position = global_position
	effect_down_right.direction = Vector2(1, 1)
	effect_down_right.get_node("AnimatedSprite2D").scale = Vector2(-1, -1)
	get_parent().call_deferred("add_child", effect_down_right)
	
	# Efecto normal de muerte
	var effect_death = death_effect_scene.instantiate()
	effect_death.global_position = global_position
	get_parent().call_deferred("add_child", effect_death)
	Global.registrar_limpieza()
	print("Basura recogida: ", Global.basura_recogida)
	drop_random_item()
	
	audio_explosion.play()
	animated_sprite_2d.visible = false
	collision_shape_2d.set_deferred("disabled", true)
	audio_explosion.finished.connect(queue_free)
