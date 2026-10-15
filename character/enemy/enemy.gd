extends CharacterBody2D
class_name Enemy

@export var health_component : HealthComponent
@export var hitbox : EnemyHitbox
@export var health_bar : ProgressBar
@export var colorable_component : Colorable

@export_group("Movement")
## Rate the enemy speeds up (px/sec^2)
@export var acceleration : float = 3000.0
## Rate the enemy slows down when it has no movement target (px/sec^2)
@export var deceleration : float = 4000.0
## Top walking speed (px/sec)
@export var max_velocity : float = 300.0
## How fast the enemy sheds speed when going faster than max_velocity (e.g. after a leap)
@export var damping : float = 6000.0
## The default vertical acceleration of the enemy, in px/sec
@export var gravity : float = 4000.0

@export_group("Defeat")
## When this enemy runs out of HP it stops being hostile and becomes a friendly NPC.
## If set, this scene is swapped in at the enemy's position. If empty, the enemy
## simply stays where it is, harmless.
@export var friendly_scene : PackedScene

@export_group("Player Awareness")
## Offset from the player's origin (their feet) to the point enemies aim at
@export var player_center_offset : Vector2 = Vector2(0, -120)

## Emitted once, when the enemy runs out of HP and stops being hostile.
signal became_friendly

var is_friendly : bool = false

var _player : Player
var _next_player_search_msec : int = 0


func _ready() -> void:
	# The hitbox deals damage to this enemy's health, so give it the reference
	# if the scene didn't already.
	if hitbox and hitbox.health_component == null:
		hitbox.health_component = health_component

	if health_component:
		health_component.health_depleted.connect(_on_health_depleted)
		health_component.health_changed.connect(_on_health_changed)
		if health_bar:
			health_bar.max_value = health_component.maximum_hp
			health_bar.value = health_component.hp


## Returns the player, or null if there isn't one in the scene.
## Looks in the "player" group first, then falls back to searching the scene
## (throttled, so a scene without a player doesn't get scanned every frame).
func get_player() -> Player:
	if is_instance_valid(_player):
		return _player
	if Time.get_ticks_msec() < _next_player_search_msec:
		return null

	var found := get_tree().get_first_node_in_group("player") as Player
	if found == null and get_tree().current_scene:
		var matches := get_tree().current_scene.find_children("*", "Player", true, false)
		if not matches.is_empty():
			found = matches[0] as Player

	if found == null:
		_next_player_search_msec = Time.get_ticks_msec() + 500
		return null

	_player = found
	# The player's body shares a physics layer with the world for now,
	# so make sure enemies never get blocked by it.
	add_collision_exception_with(_player)
	return _player


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
	get_parent().add_child(friend)
	friend.global_position = global_position
	queue_free()


func _on_health_changed(new_health: int) -> void:
	if health_bar:
		health_bar.value = new_health


func _on_health_depleted() -> void:
	become_friendly()
