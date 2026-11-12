extends GroundEnemy
class_name Hermit_Crab

enum State { NORMAL, WINDUP, STRIKE, RECOVER, CLAMMED }

signal state_changed(new_state: State)
signal clam_changed(clammed: bool)

@export var sprite: Sprite2D

@export var claw_hurtbox: EnemyHurtbox

@export_group("Claw")
@export var attack_distance : float = 150.0
@export var windup_time : float = 0.35
@export var strike_time : float = 0.2
@export var recovery_time : float = 0.3
 
@export_group("Clam")
@export var clam_time : float = 3.0

var state : State = State.NORMAL
var is_clammed : bool:
	get:
		return state == State.CLAMMED
 
var _state_timer : float = 0.0

func _ready() -> void:
	super()
	_update_player_ray()
	if claw_hurtbox:
		claw_hurtbox.monitoring = false
	else:
		printerr("Hermit crab has no claw hurtbox!")
	health_component.health_changed.connect(_on_health_changed)

func _think(delta: float) -> void:
	if state != State.NORMAL:
		accelerate_toward(0.0, delta)
		_state_timer -= delta
		if _state_timer <= 0.0:
			_advance_state()
		return
	
	if _player_is_close():
		attack()
	elif can_see_player():
		set_target(get_player_center())
		move(delta)
	else:
		has_target = false
		patrol(delta)

func can_see_player() -> bool:
	if player_ray == null:
		return false
	return player_ray.get_collider() is Player
	
func attack() -> void:
	if state != State.NORMAL or is_friendly:
		return
	if player:
		face(dir_to(player.global_position.x))
	_set_state(State.WINDUP, windup_time)

func become_friendly() -> void:
	_set_state(State.NORMAL)
	super()
	
func face(direction: int) -> void:
	super(direction)
	_update_player_ray()
	if sprite:
		sprite.flip_h = facing < 0
	if claw_hurtbox:
		claw_hurtbox.position.x = facing * absf(claw_hurtbox.position.x)	

func _advance_state() -> void:
	match state:
		State.WINDUP:
			_set_state(State.STRIKE, strike_time)
		State.STRIKE:
			_set_state(State.RECOVER, recovery_time)
		State.RECOVER:
			_set_state(State.CLAMMED, clam_time)
		State.CLAMMED:
			_set_state(State.NORMAL)

func _set_state(new_state: State, duration: float = 0.0) -> void:
	var was_clammed := is_clammed
	state = new_state
	_state_timer = duration
	has_target = false
	
	if claw_hurtbox:
		claw_hurtbox.set_deferred("monitoring", new_state == State.STRIKE)
	
	# Invulnerability: while clammed, the hitbox can't be detected, so the player's attacks never register. (Enemy.become_friendly uses the same trick.)
	if hitbox:
		hitbox.set_deferred("monitorable", new_state != State.CLAMMED)
 
	state_changed.emit(new_state)
	if was_clammed != is_clammed:
		clam_changed.emit(is_clammed)
	
func _on_health_changed(_new_health: int) -> void:
	attack()
	
func _player_is_close() -> bool:
	if player == null:
		return false
	return global_position.distance_to(player.global_position) <= attack_distance
	
func _update_player_ray() -> void:
	if player_ray == null:
		return
	player_ray.target_position = Vector2(facing * sight_range, 0.0)
	
	player_ray.force_raycast_update()
