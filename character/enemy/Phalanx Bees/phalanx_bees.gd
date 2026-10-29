extends GroundEnemy

@export var backRay : RayCast2D

@export var stunTimer : int

enum State {PATROL, CHASE, STUN}

var state : State = State.PATROL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	pass # Replace with function body.

func _think(delta: float) -> void:
	match state:
		State.PATROL:
			patrol(delta)
		State.CHASE:
			pass
		State.STUN:
			pass

## The enemy's attack. Called by the enemy's own logic when it decides to attack.:
func attack() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (can_see_player()):
		is_friendly = false
	
