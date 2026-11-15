@tool
extends GroundEnemy
class_name Lizard

enum State{
	WAITING,
	RUNNING,
	SLOWING
}

var state : State = State.WAITING:
	set(val):
		state = val
		if state == State.WAITING:
			sprite.play("idle")
		if state == State.RUNNING:
			sprite.play("run")

func _ready() -> void:
	super._ready()
	state = State.WAITING

func _think(delta: float) -> void:
	match state:
		State.WAITING:
			_wait(delta)
		State.RUNNING:
			_run(delta)
		State.SLOWING:
			_slow(delta)

func _wait(delta : float) -> void:
	if can_see_player() and player.is_on_floor() and absf(global_position.y-player.global_position.y) < 10:
		_start_run()

func _on_health_lost() -> void:
	print("OW")
	if state == State.WAITING:
		_start_run()

func _start_run() -> void:
	var new_target : Vector2 = global_position
	##Arbitrarily large distance
	new_target.x += facing_dir * 10000
	set_target(new_target)
	state = State.RUNNING

func _run(delta : float) -> void:
	move(delta)
	if _at_obstructing_terrain():
		has_target = false
		state = State.SLOWING

func _slow(delta : float) -> void:
	move(delta)
	if velocity.is_zero_approx():
		facing_dir *= -1
		_update_facing_direction()
		state = State.WAITING
