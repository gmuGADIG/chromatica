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

var state : State = State.IDLE:
	set(val):
		state = val
		#print(state)

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
	
### commented up by Crafty trying to figure out the code


func _think(delta: float) -> void:
	match state:
		State.IDLE:
			if _wander_timer <= 0.0:
				_pick_wander_point()
			fly_toward_target(idle_speed, delta)
			###If we can see the player at this point, start the approach, set lost sight time to zero
			# T If the player enters the sight range, lose-sight timer is reset
			# There is nothing else done to the lose_sight timer because the state is switched to "APPROACH"
			if can_see_player():
				_lost_sight_time = 0.0
				_start_approach()
		State.APPROACH:
			###Check for the third(?) time that we can see the player, even though this is on the same tick?
			# T lose-sight timer is reset here as well, because this if statement corresponds to a different state
			if can_see_player():
				_lost_sight_time = 0.0
			else:
				###This is set to zero regardless when calling _start_approach(), += adds to existing value, so it works(?)
				# If the player is out of the bee's sight, the lose sight timer activates
				_lost_sight_time += delta
				###Somehow if lost sight time/delta is less than lose_sight_time, the function will not return and continue moving.
				# If the lose sight timer reaches the lose sight time, it gives up the pursuit
				if _lost_sight_time >= lose_sight_time:
					has_target = false
					_enter(State.IDLE, 0.0)
					return
			set_target(_ideal_location())
			move(delta)
			_timer -= delta # only shoot with a clear view of the player

			###Because of the -=, and not =, this will gradually make _timer smaller and smaller as its not reset. Also, timer will always be less than 0 because deltatime should never report 0?, can see player check is self explanatory, it should be here.
			# T This is a countdown. Yes, I should've designed both timers to go int ehs ame direction
			if _timer <= 0.0 and can_see_player():
				_enter(State.SHOOT, aim_time)
		State.SHOOT:
			accelerate_toward(Vector2.ZERO, delta)
			_timer -= delta
			###If at 60fps, delta will be around 0.16, 30 fps update rate is 0.33ms, unless the game's engine rate isnt tied or w/e, not sure?
			###But because _timer is never reset, it will always be negative, and the -= makes it even more negative, on the same tick(?)
			#print(_timer)

			###This will never trigger because _timer is always negative due to subtracting.
			# T the _timer is reset through the _enter function
			if (_timer <= 0.11 and _timer >= 0.09):
				#print("A1")
				attack()
			###This will always trigger.
			elif _timer <= 0.0:
				#print("A2")
				attack()
				_enter(State.APPROACH, shoot_interval)


## Fires one projectile at the player's current position.
func attack() -> void:
	if projectile_scene == null:
		return
	var origin := muzzle.global_position if muzzle else global_position
	var projectile : GlobProjectile = projectile_scene.instantiate()
	add_sibling(projectile)
	projectile.global_position = origin
	projectile.launch(origin.direction_to(get_player_center()))

## The spot the bee tries to hold: off to one side of the player and above them.
func _ideal_location() -> Vector2:
	var player_pos := get_player_center()
	var dx := minf(absf(global_position.x - player_pos.x), ideal_offset.x)*0.75
	var dy := minf(absf(global_position.y - player_pos.y), ideal_offset.y)*0.75
	return player_pos + Vector2(_side * dx, dy)

func _start_approach() -> void:
	# Stay on the side of the player it's already on, so it doesn't cross through them.
	_side = int(signf(global_position.x - get_player_center().x))
	if _side == 0:
		_side = 1
	### Set lost sight time to zero again(?), then start approach state
	# T You're right, I don't think this _lost_sight_time beneath this is needed.
	_lost_sight_time = 0.0
	_enter(State.APPROACH, shoot_interval)

func _pick_wander_point() -> void:
	var offset := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * home_radius
	set_target(_home + offset)
	_wander_timer = wander_interval * randf_range(0.7, 1.3)


func _enter(new_state: State, duration: float) -> void:
	state = new_state
	_timer = duration
	if state == State.IDLE:
		_wander_timer = 0.0
