extends GroundEnemy
class_name Scorpion

enum State { PATROL, CHASE, WINDUP, STING, RECOVER }


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _think(delta: float) -> void:
	match state:
		State.PATROL:
			
		State.CHASE:
			pass
		State.WINDUP:
			pass
		State.STING:
			pass
		State.RECOVER:
			pass

## The enemy's attack. Called by the enemy's own logic when it decides to attack.:

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
