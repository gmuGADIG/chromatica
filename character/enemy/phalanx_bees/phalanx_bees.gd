extends GroundEnemy

@export var backRay : RayCast2D

@export var stunTimer : int

enum State {PATROL, CHASE, STUN}

var state : State = State.PATROL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	health_component.health_lost.connect(_on_take_damage)
	pass # Replace with function body.

func _on_take_damage() -> void:
	if state != State.PATROL:
		return
		
	var facing_check : float = (player.global_position.x - global_position.x) * get_facing_direction()
	if facing_check < 0:
		face(-get_facing_direction())
	state = State.CHASE

func _think(delta: float) -> void:
	match state:
		State.PATROL:
			patrol(delta)
			if can_see_player():
				state = State.CHASE
			pass
		State.CHASE:
			target_position.x = player.global_position.x
			##if !has_target:
				##has_target = true
			
			pass 
		State.STUN:
			stunTimer -= 1
			if stunTimer <= 0:
				state = State.CHASE
			pass

## The enemy's attack. Called by the enemy's own logic when it decides to attack.:
func attack() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_see_player():
		state = State.CHASE
	
