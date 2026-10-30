extends AirEnemy
class_name CarpenterBee
## Behavior: drifts around its home point. When it sees the player it chases,
## hovers above them, winds up, then dives straight at where they were.
## (The Enemy it is attached to hurts the player on contact through its ContactHurtbox.)

enum State { IDLE, APPROACH, SHOOT }

@export_group("Idle")
## How far from its home point the bee drifts while idle (px)
@export var home_radius : float = 250.0
## Drift speed while idle (px/sec)
@export var idle_speed : float = 120.0
## Seconds between picking new drift points
@export var wander_interval : float = 2.0

@export_group("Approach")
## The "ideal location", relative to the player's center. x is how far to the side
## (it mirrors to whichever side the bee is on), y is height (negative = above).
@export var ideal_offset : Vector2 = Vector2(350.0, -250.0)
## Seconds spent approaching before it shoots
@export var shoot_interval : float = 2.0
## Seconds without sight of the player before it gives up and goes back to idle.
## (A small grace period, so a flickering line of sight doesn't make it twitch between states.)
@export var lose_sight_time : float = 1.0

@export_group("Shoot")
## Scene spawned when shooting. Needs a launch(direction: Vector2) method (see Cannonball).
@export var projectile_scene : PackedScene
## Where projectiles spawn. Uses the bee's center if empty.
@export var muzzle : Marker2D
## Seconds the bee hangs still before firing (the player's tell)
@export var aim_time : float = 0.4

var state : State = State.IDLE

var _timer : float = 0.0
var _wander_timer : float = 0.0
var _lost_sight_time : float = 0.0
var _side : int = 1
var _home : Vector2 = Vector2.ZERO
var _home_set : bool = false

func _ready() -> void:
	super()
	_home = global_position
	if projectile_scene == null:
		push_warning("No Projectile for '%s' " % name)
	

func _think(delta: float) -> void:
	match state:
		State.IDLE:
			_wander_timer -= delta
			if _wander_timer <= 0.0:
				_pick_wander_point()
			fly_toward_target(idle_speed, delta)
			if can_see_player():
				_lost_sight_time = 0.0
				_start_approach()
		State.APPROACH:
			if can_see_player():
				_lost_sight_time = 0.0
			else:
				_lost_sight_time += delta
				if _lost_sight_time >= lose_sight_time:
					has_target = false
					_enter(State.IDLE, 0.0)
					return
			set_target(_ideal_location())
			move(delta)
			_timer -= delta# only shoot with a clear view of the player
			if _timer <= 0.0 and can_see_player():
				_enter(State.SHOOT, aim_time)
		State.SHOOT:
			accelerate_toward(Vector2.ZERO, delta)
			_timer -= delta
			if _timer <= 0.0:
				attack()
				_enter(State.APPROACH, shoot_interval)


## Fires one projectile at the player's current position.
func attack() -> void:
	if projectile_scene == null:
		return
	var origin := muzzle.global_position if muzzle else global_position
	var projectile := projectile_scene.instantiate() as Cannonball
	add_sibling(projectile)
	projectile.global_position = origin
	projectile.launch(get_player_center() - origin)

## The spot the bee tries to hold: off to one side of the player and above them.
func _ideal_location() -> Vector2:
	return get_player_center() + Vector2(_side * ideal_offset.x, ideal_offset.y)

func _start_approach() -> void:
	# Stay on the side of the player it's already on, so it doesn't cross through them.
	_side = int(signf(global_position.x - get_player_center().x))
	if _side == 0:
		_side = 1
	_lost_sight_time = 0.0
	_enter(State.APPROACH, shoot_interval)

func _pick_wander_point() -> void:
	var offset := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * home_radius
	set_target(_home + offset)
	_wander_timer = wander_interval * randf_range(0.7, 1.3)


func _enter(new_state: State, duration: float) -> void:
	state = new_state
	_timer = duration
