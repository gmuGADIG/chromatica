@abstract
class_name GroundEnemy
extends Enemy
## Behavior for enemies that walk on the ground. Add as a child of an Enemy.
## Handles gravity, patrolling, and the can_see_player() / set_target() / move() interface.
## Children implement _think() (their decision-making each physics frame) and attack().

	# "body" references the parent extended from EnemyBehavior; 
	# "Enemy, which contains borrowed variables such as:
	# "is_friendly", move_and_slide(), get_player(), global_position, is_on_wall(), is_on_floor(), velocity

@export_group("Gravity")
@export var max_falling_velocity : float = 3000.0

@export_group("Patrol")
@export var patrol_speed : float = 150.0
@export var turn_at_ledges : bool = true
## How far in front of the origin the platform_ray sits (px)
@export var ledge_check_offset : float = 60.0

@export_group("Sight")
## Horizontal distance the enemy can notice the player from
@export var sight_range : float = 800.0
## Vertical distance tolerance. Stand-in for "same platform" until platforms exist.
@export var sight_height : float = 300.0
## How close to a target x (set_target) counts as having arrived
@export var arrive_distance : float = 20.0

var has_target : bool = false
var target_position : Vector2 = Vector2.ZERO

var _turn_lock : float = 0.0


func _ready() -> void:
	super()
	face(1)


func _physics_process(delta: float) -> void:
	_turn_lock = maxf(_turn_lock - delta, 0.0)
	apply_gravity(delta)
	_think(delta)
	move_and_slide()


## Decision-making for this enemy. Called every physics frame, after gravity
## and before move_and_slide().
@abstract func _think(delta: float) -> void

## The enemy's attack. Called by the enemy's own logic when it decides to attack.
@abstract func attack() -> void


## Default: the player is within sight_range horizontally and sight_height vertically.
## TODO: swap for "last platform the player touched is this enemy's platform".
func can_see_player() -> bool:
	#aggroed enemies should always see player
	var collision = player_ray.get_collider()
	if collision is Player:
		return true
	return false


## Location to walk to. move() walks there.
func set_target(pos: Vector2) -> void:
	target_position = pos
	has_target = true


## Walks toward the target set by set_target(), stopping once it arrives.
func move(delta: float) -> void:
	if not has_target:
		accelerate_toward(0.0, delta)
		return
	var direction := dir_to(target_position.x)
	if absf(target_position.x - global_position.x) <= arrive_distance:
		has_target = false
		accelerate_toward(0.0, delta)
		return
	face(direction)
	accelerate_toward(get_facing_direction() * max_velocity, delta)


func patrol(delta: float) -> void:
	if _turn_lock <= 0.0 and is_on_floor() and (is_on_wall() or _at_ledge()):
		face(-get_facing_direction())
		_turn_lock = 0.25
	accelerate_toward(get_facing_direction() * patrol_speed, delta)

## Only call with 1 (face right) or -1 (face left)
## Usually called with face(-(get_facing_direction())) to flip the raycasts
func face(direction: int) -> void:
	if direction == 0:
		return
	var shouldFlip : int = direction * get_facing_direction()
	if (shouldFlip == -1): 
		if platform_ray:
			platform_ray.position.x = direction * ledge_check_offset
		if wall_ray:
			wall_ray.position.x *= -1
		if platform_ray:
			player_ray.position.x *= -1


## -1, 0 or 1: which way a world x position is from this enemy.
func dir_to(world_x: float) -> int:
	return int(signf(world_x - global_position.x))


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = minf(velocity.y + gravity * delta, max_falling_velocity)

func get_facing_direction() -> int:
	if velocity.x < 0: 
		return -1
	return 1

## Speeds up toward target_speed (px/sec, signed). Pass 0.0 to slow to a stop.
## Anything faster than max_velocity is damped down to it first.
func accelerate_toward(target_speed: float, delta: float) -> void:
	target_speed = clampf(target_speed, -max_velocity, max_velocity)
	if absf(velocity.x) > max_velocity:
		velocity.x = move_toward(velocity.x, signf(velocity.x) * max_velocity, dampening * delta)
	elif is_zero_approx(target_speed):
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)


func _at_ledge() -> bool:
	return turn_at_ledges and platform_ray != null and not platform_ray.is_colliding()
