@tool
extends GroundEnemy

@export var back_player_ray : RayCast2D

@export var stunTimer : int

enum State {PATROL, CHASE, STUN}

##Note: These set acceleration & max_velocity
@export_group("Movement/Patrol")
@export var patrol_acceleration : float = 750
@export var patrol_deceleration : float = 750
@export var patrol_max_velocity : float = 150
@export_group("Movement/Chase")
@export var chase_acceleration : float = 1500
@export var chase_deceleration : float = 1500
@export var chase_max_velocity : float = 300

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	health_component.health_lost.connect(_on_take_damage)
	colorable_component.combo_triggered.connect(on_combo)

func can_see_player() -> bool:
	if (super.can_see_player()):
		return true
	
	var collision = back_player_ray.get_collider()
	if collision is Player:
		return true
	return false

func _on_take_damage() -> void:
	if state != State.PATROL:
		return
		
	if !facing_player():
		facing_dir *= -1
		_update_facing_direction()
	state = State.CHASE

func on_combo(color : Paint.Hue) -> void:
	if (color == Paint.Hue.PURPLE):
		pass

func _think(delta: float) -> void:
	match state:
		State.PATROL:
			patrol(delta)
			if can_see_player():
				state = State.CHASE
			pass
		State.CHASE:
			var new_target : Vector2 = global_position
			new_target.x = player.global_position.x
			set_target(new_target)
			
			pass 
		State.STUN:
			stunTimer -= 1
			if stunTimer <= 0:
				state = State.CHASE
			pass

var turning : bool = false

func patrol(delta : float) -> void:
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
		state = State.CHASE

## The enemy's attack. Called by the enemy's own logic when it decides to attack.:
func attack() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_see_player():
		state = State.CHASE
	
