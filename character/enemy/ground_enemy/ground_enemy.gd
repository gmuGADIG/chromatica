@tool
class_name GroundEnemy
extends Enemy
## Behavior for enemies that walk on the ground. Add as a child of an Enemy.
## Handles gravity, patrolling, and the can_see_player() / set_target() / move() interface.
## Children implement _think() (their decision-making each physics frame) and attack().

enum FacingDirection{
	LEFT = -1,
	RIGHT = 1
}
	# "body" references the parent extended from EnemyBehavior; 
	# "Enemy, which contains borrowed variables such as:
	# "is_friendly", move_and_slide(), get_player(), global_position, is_on_wall(), is_on_floor(), velocity

@export_group("Gravity")
@export var max_falling_velocity : float = 3000.0

@export_group("Patrol")
@export var patrol_speed : float = 150.0
@export var turn_at_ledges : bool = true

@export_group("Sight")
## Horizontal distance the enemy can notice the player from
@export var player_sight_distance : float = 800.0
## Vertical distance tolerance. Stand-in for "same platform" until platforms exist.
@export var arrive_distance : float = 20.0

## How far the wall & platform ray goes
@export var halt_distance : float = 500.0

@export var player_ray : RayCast2D

@export var wall_ray : RayCast2D

@export var platform_ray : RayCast2D

var has_target : bool = false
var target_position : Vector2 = Vector2.ZERO
@export var facing_dir : FacingDirection = FacingDirection.LEFT:
	set(val):
		if val == 0:
			return
		facing_dir = val
		
		if Engine.is_editor_hint():
			_update_facing_direction()
		#player_ray.target_position.x = facing_dir * absf(player_ray.target_position.x)



func _ready() -> void:
	super._ready()
	_update_facing_direction()


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	apply_gravity(delta)
	_think(delta)
	move_and_slide()


## Decision-making for this enemy. Called every physics frame, after gravity
## and before move_and_slide().
func _think(delta: float) -> void:
	assert(false,"Not Implemented!")

## The enemy's attack. Called by the enemy's own logic when it decides to attack.
func attack() -> void:
	assert(false,"Not Implemented!")


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
	if absf(target_position.x - global_position.x) <= arrive_distance:
		has_target = false
	if not has_target:
		accelerate_toward(0.0, delta)
		return
	
	var target_velocity : float = dir_to(target_position.x) * max_velocity
	accelerate_toward(target_velocity, delta)


## -1, 0 or 1: which way a world x position is from this enemy.
func dir_to(world_x: float) -> int:
	return int(signf(world_x - global_position.x))


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = minf(velocity.y + gravity * delta, max_falling_velocity)


## Speeds up toward target_speed (px/sec, signed). Pass 0.0 to slow to a stop.
## Anything faster than max_velocity is damped down to it first.
func accelerate_toward(target_velocity: float, delta: float) -> void:
	
	target_velocity = clampf(target_velocity, -max_velocity, max_velocity)
	if is_zero_approx(target_velocity):
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)
	elif absf(velocity.x) > max_velocity:
		velocity.x = move_toward(velocity.x, signf(velocity.x) * max_velocity, dampening * delta)
	else:
		velocity.x = move_toward(velocity.x, target_velocity, acceleration * delta)
	
	##Turn Logic
	var moving_opposite_of_facing : bool = velocity.x * facing_dir < 0
	var moving_towards_player : bool = (get_player_center().x-global_position.x) * facing_dir > 0
	if moving_opposite_of_facing and moving_towards_player:
		facing_dir *= -1

func _update_facing_direction() -> void:
	wall_ray.target_position.x = facing_dir * halt_distance
	platform_ray.position.x = facing_dir * halt_distance
	player_ray.target_position.x = facing_dir * player_sight_distance
	sprite.flip_h = facing_dir == FacingDirection.LEFT

##When an enemy reaches a wall or ledge they should stop
func _at_obstructing_terrain() -> bool:
	return is_on_floor() and ( not platform_ray.is_colliding() or wall_ray.is_colliding() )
	return false

#func _at_ledge() -> bool:
	#return 
#
#func _at_wall() -> bool:
	#return 
