class_name FV_player
extends CharacterBody2D

@export var speed := 60.0
var can_move : bool = true

var is_attacking : bool = false
# Direccion hacia donde esta mirando Link
var facing_direction := Vector2.DOWN
@onready var sword_hitbox: Area2D = $SwordHitbox

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#Lanzamiento de la espada
@export var sword_magic_scene: PackedScene
#Controlar el casteo con varaible
var can_cast_sword: bool = true


func _ready() -> void:
	sword_hitbox.monitoring = false


func _physics_process(delta: float) -> void:

	if not can_move:
		velocity = Vector2.ZERO
		return

	#Atacar
	if Input.is_action_just_pressed("ATACAR"):
		attack()

	if is_attacking:
		return

	var direction := Input.get_vector(
		"IZQUIERDA",
		"DERECHA",
		"ARRIBA",
		"ABAJO"
		)

	velocity = direction * speed

	# Aplicar Animaciones al personaje
	if direction == Vector2.ZERO:
		if facing_direction == Vector2.DOWN:
			animated_sprite_2d.play("walk_down")
		elif facing_direction == Vector2.UP:
			animated_sprite_2d.play("walk_up")
		elif facing_direction == Vector2.RIGHT:
			animated_sprite_2d.play("walk_right")
		elif facing_direction == Vector2.LEFT:
			animated_sprite_2d.play("walk_left")
		animated_sprite_2d.pause()
		return

	if direction.x > 0:
		facing_direction = Vector2.RIGHT
		animated_sprite_2d.play("walk_right")

	elif direction.x < 0:
		facing_direction = Vector2.LEFT
		animated_sprite_2d.play("walk_left")

	elif direction.y > 0:
		facing_direction = Vector2.DOWN
		animated_sprite_2d.play("walk_down")

	elif direction.y < 0:
		facing_direction = Vector2.UP
		animated_sprite_2d.play("walk_up")

	move_and_slide()


func move_screen_transition_player(direccion: Vector2, distancia: float) -> void:
	can_move = false
	velocity = Vector2.ZERO

	if direccion.x > 0:
		animated_sprite_2d.play("walk_right")
	elif direccion.x < 0:
		animated_sprite_2d.play("walk_left")
	elif direccion.y > 0:
		animated_sprite_2d.play("walk_down")
	elif direccion.y < 0:
		animated_sprite_2d.play("walk_up")

	var tween := create_tween()
	tween.tween_property(self, "global_position", global_position + direccion * distancia, 0.5)
	await tween.finished


func attack() -> void:
	is_attacking = true
	#Ya tenemos guardado la direccion hacia donde mira el jugador y hacia esa
	#direccion ejecutamos la animacion correspondiente.
	if facing_direction == Vector2.RIGHT:
		sword_hitbox.position = Vector2(14, 0)
		animated_sprite_2d.play("Sword_Right")

	elif facing_direction == Vector2.LEFT:
		sword_hitbox.position = Vector2(-14, 0)
		animated_sprite_2d.play("Sword_Left")

	elif facing_direction == Vector2.UP:
		sword_hitbox.position = Vector2(0, -14)
		animated_sprite_2d.play("Sword_Up")

	elif facing_direction == Vector2.DOWN:
		sword_hitbox.position = Vector2(0, 14)
		animated_sprite_2d.play("Sword_Down")

	sword_hitbox.monitoring = true

	#Lanzar espada magica
	cast_sword()

	await animated_sprite_2d.animation_finished
	sword_hitbox.monitoring = false

	is_attacking = false
	print(is_attacking)


func _on_sword_hitbox_area_entered(area: Area2D) -> void:
	print("Area Detectada" + area.name)
	var enemy = area.get_parent()

	print("Padre: ", enemy.name)
	print("Pertece al grupo: ", area.get_parent().get_groups())

	if enemy.is_in_group("ENEMIES"):
		enemy.take_damage()


func cast_sword() -> void:

	if not can_cast_sword:
		return

	can_cast_sword = false

	var swordMagic : FV_swordMagic_scene = sword_magic_scene.instantiate()

	get_parent().add_child(swordMagic)

	swordMagic.global_position = global_position
	swordMagic.direction = facing_direction
	swordMagic.rotation = facing_direction.angle() + PI / 2

	await get_tree().create_timer(1.0).timeout

	can_cast_sword = true
