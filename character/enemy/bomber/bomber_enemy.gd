## NOTE! 
## This is a prototype enemy who's purpose is to demonstrate programing potential.
## This enemy was not part of Ayame's pitch nor the design team's concept.
## This entity should not be present in the base game scenes unless specified.

class_name BomberEnemy
extends AirEnemy
## Flies back and forth above the player and drops a Bomb whenever it passes over them.

@export_group("Bombing")
## The bomb to drop (bomb.tscn)
@export var bomb_scene : PackedScene
## Where the bomb spawns, relative to this enemy (px)
@export var bomb_spawn_offset : Vector2 = Vector2(0, 70)
## Seconds between drops
@export var drop_cooldown : float = 2.5
## How close (horizontally) the enemy must be to the player to drop a bomb (px)
@export var drop_x_tolerance : float = 120.0

@export_group("Hovering")
## How far above the player's center the enemy flies (px)
@export var hover_height : float = 350.0
## How far it sweeps left/right of the player while hovering (px)
@export var sweep_amplitude : float = 250.0
## Sweep speed (radians/sec). Higher = swings back and forth faster
@export var sweep_speed : float = 1.5

var _cooldown : float = 1.0 # short delay before the first drop
var _time : float = 0.0


func _think(delta: float) -> void:
	_cooldown = maxf(_cooldown - delta, 0.0)
	_time += delta

	if not can_see_player():
		accelerate_toward(Vector2.ZERO, delta)
		return

	var center := get_player_center()
	set_target(center + Vector2(sin(_time * sweep_speed) * sweep_amplitude, -hover_height))
	move(delta)

	if _cooldown <= 0.0 and absf(center.x - global_position.x) <= drop_x_tolerance:
		attack()


func attack() -> void:
	if bomb_scene == null:
		printerr("BomberEnemy has no bomb_scene!")
		return
	_cooldown = drop_cooldown

	var bomb := bomb_scene.instantiate() as Bomb
	# Added to the scene (not to this enemy) so the bomb survives if the enemy
	# becomes friendly and swaps scenes.
	get_tree().current_scene.add_child(bomb)
	bomb.global_position = global_position + bomb_spawn_offset
	# Inherit the enemy's horizontal speed so the bomb drops in an arc, not straight down
	bomb.velocity = Vector2(velocity.x, 0.0)
