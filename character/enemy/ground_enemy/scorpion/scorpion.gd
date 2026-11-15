@tool
extends GroundEnemy
class_name Scorpion

enum State{
	PATROL,
	CHASE,
	ATTACK,
}

##How brainrotted is the scorpion (Time before it stops chasing the player)
@export var attention_span : float = 7.0
@export var stinger_hurtbox : EnemyHurtbox
##Note: These set acceleration & max_velocity
@export_group("Movement/Patrol")
@export var patrol_acceleration : float = 1500
@export var patrol_deceleration : float = 1500
@export var patrol_max_velocity : float = 300
@export_group("Movement/Chase")
@export var chase_acceleration : float = 2000
@export var chase_deceleration : float = 2000
@export var chase_max_velocity : float = 400

var time_since_last_seen : float = 0.0

var state : State = State.PATROL:
	set(val):
		state = val
		match state:
			State.PATROL:
				sprite.speed_scale = 1
				acceleration = patrol_acceleration
				deceleration = patrol_deceleration
				max_velocity = patrol_max_velocity
			State.CHASE:
				sprite.speed_scale = 1.5
				acceleration = chase_acceleration
				deceleration = chase_deceleration
				max_velocity = chase_max_velocity
			_:
				pass
var turning : bool = false

func _ready() -> void:
	stinger_hurtbox.disable()
	super._ready()
	state = State.PATROL

func _think(delta: float) -> void:
	match state:
		State.PATROL:
			_patrol(delta)
		State.CHASE:
			_chase(delta)
		State.ATTACK:
			_attack(delta)
	
	##Animation
	if state == State.PATROL or state == State.CHASE:
		if is_zero_approx(velocity.x) and sprite.is_playing():
			sprite.pause()
		elif not (is_zero_approx(velocity.x) or sprite.is_playing()):
			sprite.play()

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
		time_since_last_seen = 0
		state = State.CHASE

func _on_health_lost() -> void:
	if state == State.PATROL:
		time_since_last_seen = 0
		state = State.CHASE

func _chase(delta : float) -> void:
	if can_see_player():
		time_since_last_seen = 0
	time_since_last_seen += delta
	#print(time_since_last_seen)
	if time_since_last_seen > attention_span:
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
		state = State.ATTACK
		await get_tree().create_timer(0.5).timeout
		stinger_hurtbox.position.x = 128 * facing_dir
		stinger_hurtbox.enable()
		await get_tree().create_timer(3.0).timeout
		stinger_hurtbox.disable()
		await get_tree().create_timer(0.5).timeout
		state = State.CHASE

func _attack(delta : float) -> void:
	has_target = false
	move(delta)
