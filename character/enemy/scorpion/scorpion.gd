extends GroundEnemy
class_name Scorpion

enum State { PATROL, CHASE, WINDUP, STING, RECOVER }

var state : State = State.PATROL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _think(delta: float) -> void:
	match state:
		State.PATROL:
			patrol(1)
		State.CHASE:
			pass
		State.WINDUP:
			pass
		State.STING:
			attack()
		State.RECOVER:
			pass

## The enemy's attack. Called by the enemy's own logic when it decides to attack.:
func attack():
	pass
