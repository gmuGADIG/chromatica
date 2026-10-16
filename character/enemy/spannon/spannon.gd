extends GroundEnemy
class_name Spannon
## Walks around. When it has line of sight to the player it slows to a stop,
## turns its cannon toward them, and fires cannonballs.

@export_group("Cannon")
## The node that rotates. Its barrel should point along +X at rotation 0.
@export var cannon : Node2D
## Where cannonballs spawn (child of the cannon)
@export var muzzle : Marker2D
@export var cannonball_scene : PackedScene

@export_group("Shooting")
## Seconds between first spotting the player and the first shot
@export var aim_delay : float = 0.8
## Seconds between shots while the player stays in sight
@export var fire_interval : float = 2.0
## How fast the cannon turns (radians/sec)
@export var aim_turn_speed : float = 3.0
## How closely the cannon must point at the player before it can fire (degrees)
@export var aim_tolerance_degrees : float = 6.0
## Physics layers that block line of sight. Include the player's layer
## (it's checked for explicitly, so it doesn't count as blocking).
@export_flags_2d_physics var sight_mask : int = 3

var _fire_timer : float = 0.0


func _ready() -> void:
	super()
	if cannon == null or muzzle == null or cannonball_scene == null:
		push_warning("Spannon '%s' is missing its cannon, muzzle, or cannonball_scene." % name)


func _think(delta: float) -> void:
	_fire_timer = maxf(_fire_timer - delta, 0.0)

	if can_see_player():
		var target := body.get_player_center()
		face(dir_to(target.x))
		accelerate_toward(0.0, delta)
		var angle := _angle_to(target)
		_rotate_cannon_toward(angle, delta)
		if _fire_timer <= 0.0 and _is_aimed_at(angle):
			attack()
	else:
		patrol(delta)
		_rotate_cannon_toward(0.0 if facing > 0 else PI, delta)
		# Restart the aim delay so it doesn't fire the instant it spots the player
		_fire_timer = maxf(_fire_timer, aim_delay)


## Fires one cannonball in the direction the cannon is pointing.
func attack() -> void:
	_fire_timer = fire_interval
	if cannonball_scene == null or muzzle == null or cannon == null:
		return
	var ball := cannonball_scene.instantiate() as Cannonball
	get_parent().add_child(ball)
	ball.global_position = muzzle.global_position
	ball.launch(Vector2.RIGHT.rotated(cannon.global_rotation))


## Needs an unobstructed line from the cannon to the player, within sight_range.
func can_see_player() -> bool:
	var player := body.get_player()
	if player == null:
		return false
	var target := body.get_player_center()
	var origin := cannon.global_position if cannon else body.global_position
	if origin.distance_to(target) > sight_range:
		return false

	var query := PhysicsRayQueryParameters2D.create(origin, target, sight_mask, [body.get_rid()])
	var result := body.get_world_2d().direct_space_state.intersect_ray(query)
	return result.is_empty() or result["collider"] == player


func _angle_to(world_position: Vector2) -> float:
	var origin := cannon.global_position if cannon else body.global_position
	return (world_position - origin).angle()


func _rotate_cannon_toward(angle: float, delta: float) -> void:
	if cannon == null:
		return
	var step := aim_turn_speed * delta
	cannon.global_rotation += clampf(angle_difference(cannon.global_rotation, angle), -step, step)


func _is_aimed_at(angle: float) -> bool:
	if cannon == null:
		return true
	return absf(angle_difference(cannon.global_rotation, angle)) <= deg_to_rad(aim_tolerance_degrees)
