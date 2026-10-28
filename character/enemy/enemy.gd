
extends CharacterBody2D
class_name Enemy

## Emitted once, when the enemy runs out of HP and stops being hostile.
signal became_friendly


@export_group("Movement")

## Rate the enemy speeds up (px/sec^2)
@export var acceleration : float = 3000.0

## Rate the enemy slows down when it has no movement target (px/sec^2)
@export var deceleration : float = 4000.0

## Top running speed (px/sec)
@export var max_velocity : float = 300.0

## How fast the enemy sheds speed when going faster than max_velocity (e.g. after a leap)
@export var dampening : float = 6000.0

## Downward acceleration (px/sec^2)
@export var gravity : float = 4000.0


@export_group("Combat")

@export var is_friendly : bool

@export var health_component : HealthComponent

@export var hitbox : EnemyHitbox

@export var health_bar : ProgressBar

@export var colorable_component : Colorable

@export var player_ray : RayCast2D

@export var wall_ray : RayCast2D

@export var platform_ray : RayCast2D

## ----------------------------------------------------
## Movement group has migrated to @enemy_behavior.gd
## ----------------------------------------------------

@export_group("Defeat")
## When this enemy runs out of HP it stops being hostile and becomes a friendly NPC.
## If set, this scene is swapped in at the enemy's position. If empty, the enemy
## simply stays where it is, harmless.
@export var friendly_scene : PackedScene

@export_group("Player Awareness")
## Offset from the player's origin (their feet) to the point enemies aim at
@export var player_center_offset : Vector2 = Vector2(0, -120)




@onready var player : Player = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	if player == null:
		printerr("No player found!")
	if health_component == null:
		printerr("No Health component!")
	
	health_component.health_depleted.connect(become_friendly)


## Returns the player, or null if there isn't one in the scene.
## Looks in the "player" group first, then falls back to searching the scene
## (throttled, so a scene without a player doesn't get scanned every frame).
func get_player() -> Player:
	return player


## World position of the point enemies aim at / check line of sight to.
func get_player_center() -> Vector2:
	var player := get_player()
	if player == null:
		return global_position
	return player.global_position + player_center_offset


## Called when HP runs out. Nobody dies: the enemy turns friendly.
## Override to add animation, dialogue, etc. (call super() to keep the base behavior).
func become_friendly() -> void:
	if is_friendly:
		return
	is_friendly = true

	# Stop being a target and stop being a threat.
	if hitbox:
		hitbox.set_deferred("monitorable", false)
	for hurtbox in find_children("*", "EnemyHurtbox", true, false):
		(hurtbox as EnemyHurtbox).disable()
	if health_bar:
		health_bar.hide()

	became_friendly.emit()
	if friendly_scene:
		_swap_to_friendly_scene.call_deferred()


func _swap_to_friendly_scene() -> void:
	var friend := friendly_scene.instantiate() as Node2D
	add_sibling(friend)
	friend.global_position = global_position
	queue_free()


func can_see_player() -> bool:
	printerr("Method Not Implemented!")
	return false

func set_target(pos: Vector2) -> void:
	printerr("Method Not Implemented!")

func move(delta: float) -> void:
	printerr("Method Not Implemented!")

func attack() -> void:
	printerr("Not Implemented!")
