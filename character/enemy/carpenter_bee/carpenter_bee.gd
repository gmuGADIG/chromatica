extends AirEnemy
class_name CarpenterBee
## Behavior: drifts around its home point. When it sees the player it chases,
## hovers above them, winds up, then dives straight at where they were.
## (The Enemy it is attached to hurts the player on contact through its ContactHurtbox.)

enum State { IDLE, CHASE, WINDUP, DASH, RECOVER }

@export_group("Idle")
## How far from its home point the bee drifts while idle (px)
@export var home_radius : float = 250.0
## Drift speed while idle (px/sec)
@export var idle_speed : float = 120.0
## Seconds between picking new drift points
@export var wander_interval : float = 2.0

@export_group("Chase")
## Where the bee positions itself relative to the player before diving (px)
@export var hover_offset : Vector2 = Vector2(0.0, -350.0)
## How close to that spot the bee must get before it dives (px)
@export var dive_distance : float = 150.0
## Seconds without seeing the player before it gives up and goes back to idle
@export var lose_sight_time : float = 2.0

#
# REWORK THIS GROUP TO SUIT PROJECTILE ATTACK
@export_group("Dash")
## Seconds spent hovering still before the dive (the player's chance to react)
@export var windup_time : float = 0.6
@export var dash_speed : float = 1300.0
## Longest a dive can last (it also ends early when the bee hits something)
@export var dash_time : float = 0.5
## Seconds spent slowing down after a dive
@export var recover_time : float = 1.0

var state : State = State.IDLE

var _timer : float = 0.0
var _wander_timer : float = 0.0
var _lost_sight_time : float = 0.0
var _home : Vector2 = Vector2.ZERO
var _home_set : bool = false


func _think(delta: float) -> void:
	if not _home_set:
		_home = global_position
		_home_set = true

	match state:
		State.IDLE:
			_wander_timer -= delta
			if _wander_timer <= 0.0:
				_pick_wander_point()
			fly_toward_target(idle_speed, delta)
			if can_see_player():
				_lost_sight_time = 0.0
				_enter(State.CHASE, 0.0)
		State.CHASE:
			if can_see_player():
				_lost_sight_time = 0.0
			else:
				_lost_sight_time += delta
				if _lost_sight_time >= lose_sight_time:
					has_target = false
					_enter(State.IDLE, 0.0)
					return
			var hover_point := get_player_center() + hover_offset
			set_target(hover_point)
			move(delta)
			if can_see_player() and global_position.distance_to(hover_point) <= dive_distance:
				_enter(State.WINDUP, windup_time)
		State.WINDUP:
			accelerate_toward(Vector2.ZERO, delta)
			_timer -= delta
			if _timer <= 0.0:
				attack()
		State.DASH:
			# Switch State Name to "Shoot", use "Spannon's" projectile concept
			# Also replace the sprite with "a fucking aspid"
			
			# Holds its dive velocity; ends on time or on hitting something.
			_timer -= delta
			if _timer <= 0.0 or is_on_floor() or is_on_wall() or is_on_ceiling():
				_enter(State.RECOVER, recover_time)
		State.RECOVER:
			accelerate_toward(Vector2.ZERO, delta)
			_timer -= delta
			if _timer <= 0.0:
				_enter(State.CHASE, 0.0)


## Dives at where the player is right now.
func attack() -> void:
	var direction := get_player_center() - global_position
	if direction.is_zero_approx():
		direction = Vector2.DOWN
	velocity = direction.normalized() * dash_speed # Rework for Cannon Prog
	_enter(State.DASH, dash_time) # Rework for Cannon Prog


func _pick_wander_point() -> void:
	var offset := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * home_radius
	set_target(_home + offset)
	_wander_timer = wander_interval * randf_range(0.7, 1.3)


func _enter(new_state: State, duration: float) -> void:
	state = new_state
	_timer = duration
