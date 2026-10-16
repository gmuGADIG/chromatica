@abstract
class_name GroundEnemy
extends EnemyBehavior
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
## Floor-check ray pointing down, placed just in front of the enemy. (child of the Enemy)
@export var ledge_check : RayCast2D
## How far in front of the origin the ledge check sits (px)
@export var ledge_check_offset : float = 60.0

@export_group("Sight")
## Horizontal distance the enemy can notice the player from
@export var sight_range : float = 800.0
## Vertical distance tolerance. Stand-in for "same platform" until platforms exist.
@export var sight_height : float = 300.0
## How close to a target x (set_target) counts as having arrived
@export var arrive_distance : float = 20.0

## 1 = facing right, -1 = facing left
var facing : int = 1
var has_target : bool = false
var target_position : Vector2 = Vector2.ZERO

var _turn_lock : float = 0.0


func _ready() -> void:
	super()
	face(facing)


func _physics_process(delta: float) -> void:
	_turn_lock = maxf(_turn_lock - delta, 0.0)
	apply_gravity(delta)

	if body.is_friendly:
		# Deactivate the Enemy AI, halt movement
		accelerate_toward(0.0, delta)
	else:
		_think(delta)
	body.move_and_slide()


## Decision-making for this enemy. Called every physics frame, after gravity
## and before move_and_slide().
@abstract func _think(delta: float) -> void

## The enemy's attack. Called by the enemy's own logic when it decides to attack.
@abstract func attack() -> void


## Default: the player is within sight_range horizontally and sight_height vertically.
## TODO: swap for "last platform the player touched is this enemy's platform".
func can_see_player() -> bool:
	var player := body.get_player()
	if player == null:
		return false
	var offset := player.global_position - body.global_position
	return absf(offset.x) <= sight_range and absf(offset.y) <= sight_height


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
	if absf(target_position.x - body.global_position.x) <= arrive_distance:
		has_target = false
		accelerate_toward(0.0, delta)
		return
	face(direction)
	accelerate_toward(facing * max_velocity, delta)


func patrol(delta: float) -> void:
	if _turn_lock <= 0.0 and body.is_on_floor() and (body.is_on_wall() or _at_ledge()):
		face(-facing)
		_turn_lock = 0.25
	accelerate_toward(facing * patrol_speed, delta)


func face(direction: int) -> void:
	if direction == 0:
		return
	facing = 1 if direction > 0 else -1
	if ledge_check:
		ledge_check.position.x = facing * ledge_check_offset


## -1, 0 or 1: which way a world x position is from this enemy.
func dir_to(world_x: float) -> int:
	return int(signf(world_x - body.global_position.x))


func apply_gravity(delta: float) -> void:
	if not body.is_on_floor():
		body.velocity.y = minf(body.velocity.y + gravity * delta, max_falling_velocity)


## Speeds up toward target_speed (px/sec, signed). Pass 0.0 to slow to a stop.
## Anything faster than max_velocity is damped down to it first.
func accelerate_toward(target_speed: float, delta: float) -> void:
	target_speed = clampf(target_speed, -max_velocity, max_velocity)
	if absf(body.velocity.x) > max_velocity:
		body.velocity.x = move_toward(body.velocity.x, signf(body.velocity.x) * max_velocity, dampening * delta)
	elif is_zero_approx(target_speed):
		body.velocity.x = move_toward(body.velocity.x, 0.0, deceleration * delta)
	else:
		body.velocity.x = move_toward(body.velocity.x, target_speed, acceleration * delta)


func _at_ledge() -> bool:
	return turn_at_ledges and ledge_check != null and not ledge_check.is_colliding()
