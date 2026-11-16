@tool
extends GroundEnemy
class_name HermitCrab

enum State {
	PATROL,
	CHASE,
	WINDUP,
	STRIKE,
	CLAMMED,
	CLAM_TRANSITION
}

signal state_changed(new_state: State)
signal clam_changed(clammed: bool)

@export var claw_hurtbox: EnemyHurtbox


@export_group("Chase")
##How brainrotted is the scorpion (Time before it stops chasing the player)
@export var attention_span : float = 7.0

@export_group("Claw")
@export var attack_distance : float = 150.0
@export var windup_time : float = 0.35
@export var strike_time : float = 0.2
@export var recovery_time : float = 0.3
@export var claw_particles : CPUParticles2D
 
@export_group("Clam")
@export var clam_duration : float = 3.0


var state : State = State.PATROL:
	set(val):
		state = val
		match state:
			State.PATROL:
				sprite.play("walk")
			State.WINDUP:
				sprite.play("idle")
			State.STRIKE:
				sprite.play("shove")
		
var is_clammed : bool:
	get:
		return state == State.CLAMMED

var time_since_last_seen_player : float = 0.0
var turning : bool = false
var clam_time : float = 0.0

func _ready() -> void:
	super._ready()
	
	
	##Error Checking
	if not claw_hurtbox:
		printerr("Hermit crab has no claw hurtbox!")
	if not hitbox:
		printerr("Missing hitbox reference")
	assert(hitbox is SpecialEnemyHitbox, "Scorpion depends on a special enemy hitbox to function")
	
	claw_hurtbox.disable()
	health_component.health_lost.connect(_on_health_lost)

func _think(delta: float) -> void:
	match state:
		State.PATROL:
			_patrol(delta)
		State.CHASE:
			_chase(delta)
			#_chase(delta)
		State.STRIKE:
			_strike(delta)
		State.CLAMMED:
			_clammed(delta)
			#_attack(delta)
	#if state != State.NORMAL:
		#accelerate_toward(0.0, delta)
		#_state_timer -= delta
		#if _state_timer <= 0.0:
			#_advance_state()
		#return
	#
	#if _player_is_close():
		#attack()
	#elif can_see_player():
		#set_target(get_player_center())
		#move(delta)
	#else:
		#has_target = false
		#patrol(delta)
	pass

func _patrol(delta : float) -> void:
	
	##Run into obstacle. Setting these variables will slow the enemy down to 0 velocity
	if has_target and _at_obstructing_terrain():
		has_target = false
		turning = true
	
	##Once the enemy reaches 0 velocity, it will initiate a turn around
	if turning and is_zero_approx(velocity.x):
		facing_dir *= -1
		_update_facing_direction()
		turning = false
	
	##Walks in a straight line towards the facing dir
	if not (has_target or turning):
		var new_target : Vector2 = global_position
		##Arbitrarily large distance
		new_target.x += facing_dir * 10000
		#print(new_target.x)
		set_target(new_target)
	
	
	move(delta)
	
	if can_see_player():
		time_since_last_seen_player = 0
		state = State.CHASE

func _chase(delta : float) -> void:
	if can_see_player():
		time_since_last_seen_player = 0
	time_since_last_seen_player += delta
	#print(time_since_last_seen)
	if time_since_last_seen_player > attention_span:
		state = State.PATROL
	
	if _at_obstructing_terrain() and facing_player():
		has_target = false
	else:
		set_target(player.global_position)
	#print(moving_towards_player())
	if moving_opposite_of_facing() and moving_towards_player():
		facing_dir *= -1
		_update_facing_direction()
	move(delta)
	
	var near_player : bool = absf(player.global_position.x-global_position.x) <= arrive_distance
	if facing_player() and near_player and is_zero_approx(player.velocity.x) and player.is_on_floor():
		attack()

func _strike(delta : float) -> void:
	has_target = false
	move(delta)

func _clammed(delta : float) -> void:
	has_target = false
	move(delta)
	clam_time += delta
	if clam_time >= clam_duration:
		sprite.play("exit_shell")
		await sprite.animation_finished
		state = State.PATROL

func attack(windup : float = windup_time) -> void:
	state = State.WINDUP
	print("ATTACKING")
	await get_tree().create_timer(windup).timeout
	state = State.STRIKE
	claw_hurtbox.position.x = attack_distance * facing_dir
	claw_particles.position.x = claw_hurtbox.position.x
	claw_hurtbox.enable()
	claw_particles.emitting = true
	await get_tree().create_timer(0.3).timeout
	claw_hurtbox.disable()
	await get_tree().create_timer(recovery_time).timeout
	clam()


func clam() -> void:
	state = State.CLAM_TRANSITION
	clam_time = 0
	sprite.play("enter_shell")
	await sprite.animation_finished
	state = State.CLAMMED

func _on_health_lost() -> void:
	if state == State.PATROL:
		state = State.CHASE


func _on_possible_hit(damage_info: DamageInfo) -> void:
	if state == State.CLAM_TRANSITION:
		return
	
	if state == State.CLAMMED:
		state = State.CLAM_TRANSITION
		print("HIT")
		sprite.play("exit_shell")
		await sprite.animation_finished
		attack(0)
		return
	hitbox.true_hit(damage_info)
