class_name FV_octorok_scene
extends CharacterBody2D

#Sonido de explosion
@onready var audio_explosion: AudioStreamPlayer2D = $AudioExplosion
#Desactivar la collision
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


var health: int = 1
#Colocar una bandera para que no se ejecute muchas veces el metodo Die
var is_dead: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer_cooldown: Timer = $TimerCooldown

@onready var ray_cast_up: RayCast2D = $RayCast_Up
@onready var ray_cast_down: RayCast2D = $RayCast_Down
@onready var ray_cast_right: RayCast2D = $RayCast_Right
@onready var ray_cast_left: RayCast2D = $RayCast_Left

@export var SPEED := 30.0

#Efectos visuales
@export var death_expand_scene: PackedScene
@export var death_effect_scene: PackedScene

#Items
@export var rupie_scene: PackedScene
@export var heart_scene: PackedScene
@export var bomba_scene: PackedScene

var direction = Vector2.DOWN
var array_directions := [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.RIGHT,
	Vector2.LEFT
]

func _ready() -> void:
	direction = array_directions.pick_random()

func _physics_process(delta: float) -> void:
	velocity = direction * SPEED
	move_and_slide()
	animations()
	
	#Comprobar la direccion y verifico si estoy colisionando hacia esa direccion
	#de ser asi, entonces elegimos un nuevo camino.
	if direction == Vector2.UP and ray_cast_up.is_colliding():
		change_direction()
	elif direction == Vector2.DOWN and ray_cast_down.is_colliding():
		change_direction()
	elif direction == Vector2.RIGHT and ray_cast_right.is_colliding():
		change_direction()
	elif direction == Vector2.LEFT and ray_cast_left.is_colliding():
		change_direction()
	

func _process(delta: float) -> void:
	pass#Se elimino la validacion de la vida.

#Recibir daño
func take_damage() -> void:
	#Colocamos la bandera
	if is_dead:
		return
	
	health -= 1
	print("Vida del Octorok: ", health)

	if health <= 0:
		die()

func _on_timer_cooldown_timeout() -> void:
	print("Tiempo terminado")
	change_direction()
	
func animations() -> void:
	if direction == Vector2.UP:
		animated_sprite_2d.play("move_up")
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("move_down")
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.play("move_rigth")
	elif direction == Vector2.LEFT:
		animated_sprite_2d.play("move_left")
	
func change_direction() -> void:
	var available_directions := []
	var direcciones := [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	var rayos := [ray_cast_up, ray_cast_down, ray_cast_left, ray_cast_right]

	for i in direcciones.size():
		var dir: Vector2 = direcciones[i]
		var siguiente_pos: Vector2 = global_position + dir * 16
		if not rayos[i].is_colliding() and es_agua(siguiente_pos):
			available_directions.append(dir)

	if available_directions.is_empty():
		return

	direction = available_directions.pick_random()
#----------------------------------
#Soltar Objeto Aleatorio
#----------------------------------
func drop_random_item() -> void:
	#Generamos un valor random
	var random_number : int = randi_range(1,100)
	
	#Creamos una variable para almacenar el item a recolectar
	var item_scene: PackedScene = null
	
	#70% no suelta nada
	#50% bomba
	#30% rupia
	#20% corazon
	
	if random_number <= 20:
		item_scene = bomba_scene
	elif random_number <= 30:
		item_scene = rupie_scene
	elif random_number <= 50:
		item_scene = heart_scene
	else:
		item_scene = null
	
	#Instanciamos el item
	if item_scene != null:
		var item = item_scene.instantiate()
		
		#Hacemos que aparesca en la posicion donde murio
		item.global_position = global_position
		
		#Agregamos el item en diferido al mismo padre del este enemigo
		#get_parent().add_child(item)
		get_parent().call_deferred("add_child", item)
		
func es_agua(pos: Vector2) -> bool:
	var mapa: TileMapLayer = get_tree().current_scene.get_node("Tiles_Group/TileMapLayer_overworld")
	var celda: Vector2i = mapa.local_to_map(mapa.to_local(pos))
	var datos: TileData = mapa.get_cell_tile_data(celda)
	if datos == null:
		return false
	return datos.get_custom_data("Agua") == true
#Funcion de muerte del enemigo 
func die() -> void:
	
	is_dead = true

	set_physics_process(false)

	# Diagonal arriba-izquierda ↖
	var effect_up_left = death_expand_scene.instantiate()
	effect_up_left.global_position = global_position
	effect_up_left.direction = Vector2(-1, -1)#x(-1) y(-1)
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
	
	#Creamos el efecto normal de muerte
	var effect_death  = death_effect_scene.instantiate()
	effect_death.global_position = global_position
	get_parent().call_deferred("add_child", effect_death)
	
	
	Global.registrar_limpieza()
	# Soltar objeto
	drop_random_item()
	
	audio_explosion.play()
	animated_sprite_2d.visible = false
	collision_shape_2d.set_deferred("disabled", true)
	audio_explosion.finished.connect(queue_free)

	
