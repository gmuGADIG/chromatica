extends GroundEnemy
class_name Lunger
## Patrols until it notices the player, winds up, then leaps at where the player
## was standing. Hurts the player on contact at all times (see ContactHurtbox).

enum State { PATROL, WINDUP, LEAP, RECOVER }

@export_group("Lunge")
## Seconds spent crouching before the leap (the player's chance to react)
@export var windup_time : float = 0.5
## Seconds spent helpless after landing
@export var recover_time : float = 0.9
## Height of the leap's arc above the launch point (px)
@export var leap_height : float = 300.0
## Cap on horizontal speed during the leap (px/sec)
@export var max_leap_speed : float = 1400.0

var state : State = State.PATROL

var _timer : float = 0.0
var _air_time : float = 0.0


func _think(delta: float) -> void:
	match state:
		State.PATROL:
			patrol(delta)
			if body.is_on_floor() and can_see_player():
				_enter(State.WINDUP, windup_time)
		State.WINDUP:
			accelerate_toward(0.0, delta)
			var player := body.get_player()
			if player:
				face(dir_to(player.global_position.x))
			_timer -= delta
			if _timer <= 0.0:
				attack()
		State.LEAP:
			_air_time += delta
			if _air_time > 0.1 and body.is_on_floor():
				_enter(State.RECOVER, recover_time)
		State.RECOVER:
			accelerate_toward(0.0, delta)
			_timer -= delta
			if _timer <= 0.0:
				_enter(State.PATROL, 0.0)


## Launches along an arc that lands on the player's current position.
func attack() -> void:
	var offset := body.get_player_center() - body.global_position
	var player := body.get_player()
	if player == null:
		offset = Vector2(facing * 300.0, 0.0)

	var launch_speed := -sqrt(2.0 * gravity * leap_height)
	# A target above the arc's peak can't be reached; aim just under the peak instead.
	var rise := maxf(offset.y, -leap_height + 1.0)
	# Time for y(t) = launch_speed * t + 0.5 * gravity * t^2 to reach `rise`
	var flight_time := (-launch_speed + sqrt(launch_speed * launch_speed + 2.0 * gravity * rise)) / gravity

	var horizontal := clampf(offset.x / flight_time, -max_leap_speed, max_leap_speed)
	body.velocity = Vector2(horizontal, launch_speed)
	face(int(signf(horizontal)))
	_air_time = 0.0
	_enter(State.LEAP, 0.0)


func _enter(new_state: State, duration: float) -> void:
	state = new_state
	_timer = duration
