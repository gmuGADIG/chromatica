@abstract
class_name AirEnemy
extends EnemyBehavior
## Behavior for flying enemies. Add as a child of an Enemy.
## Flies freely in 2D (no gravity) and implements the can_see_player() /
## set_target() / move() interface. Children implement _think() and attack().

@export_group("Sight")
## How close the player must be for the enemy to notice them (px)
@export var sight_range : float = 900.0
## Physics layers that block line of sight. Include the player's layer
## (it's checked for explicitly, so it doesn't count as blocking).
@export_flags_2d_physics var sight_mask : int = 3

@export_group("Flight")
## How close to the target counts as having arrived (px)
@export var arrive_distance : float = 20.0
## Within this distance of the target the enemy eases off so it doesn't overshoot (px)
@export var slow_radius : float = 200.0

var has_target : bool = false
var target_position : Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	if body.is_friendly:
		# No more AI: just drift to a stop.
		accelerate_toward(Vector2.ZERO, delta)
	else:
		_think(delta)
	body.move_and_slide()


## Decision-making for this enemy. Called every physics frame, before the body moves.
@abstract func _think(delta: float) -> void


## The player is close enough AND nothing solid is between this enemy and them.
func can_see_player() -> bool:
	var player := body.get_player()
	if player == null:
		return false
	var target := body.get_player_center()
	if body.global_position.distance_to(target) > sight_range:
		return false

	var query := PhysicsRayQueryParameters2D.create(body.global_position, target, sight_mask, [body.get_rid()])
	var result := body.get_world_2d().direct_space_state.intersect_ray(query)
	return result.is_empty() or result["collider"] == player


## Location to fly to. move() flies there.
func set_target(pos: Vector2) -> void:
	target_position = pos
	has_target = true


## Flies toward the target set by set_target() at max_velocity.
func move(delta: float) -> void:
	fly_toward_target(max_velocity, delta)


## Same as move(), but at a chosen top speed.
func fly_toward_target(speed: float, delta: float) -> void:
	if not has_target:
		accelerate_toward(Vector2.ZERO, delta)
		return
	var offset := target_position - body.global_position
	var distance := offset.length()
	if distance <= arrive_distance:
		has_target = false
		accelerate_toward(Vector2.ZERO, delta)
		return
	var desired_speed := speed * minf(distance / slow_radius, 1.0)
	accelerate_toward(offset / distance * desired_speed, delta)


## Speeds up toward target_velocity (px/sec). Pass Vector2.ZERO to slow to a stop.
## Anything faster than max_velocity is damped down to it first.
func accelerate_toward(target_velocity: Vector2, delta: float) -> void:
	target_velocity = target_velocity.limit_length(max_velocity)
	var current := body.velocity
	if current.length() > max_velocity:
		current = current.move_toward(current.normalized() * max_velocity, dampening * delta)
	elif target_velocity.is_zero_approx():
		current = current.move_toward(Vector2.ZERO, deceleration * delta)
	else:
		current = current.move_toward(target_velocity, acceleration * delta)
	body.velocity = current
