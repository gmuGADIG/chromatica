extends Node

@export var player: CharacterBody2D
@export var playerInput: Node

# Goes from Player Input to HPM

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Movement(delta: float, velocity: Vector2) -> Vector2:
	var direction: float = playerInput.GetDirection()
	if direction:
		# Right
		if direction > 0:
			velocity.x += direction * (player.acceleration * delta)
			print("First Vel: ", velocity.x, " | ", player.acceleration)
			if velocity.x > player.maxVelocity:
				velocity.x -= move_toward(velocity.x, velocity.x - player.maxVelocity, player.dampening)
			print("2nd Vel: ", velocity.x)
		# Left
		elif direction < 0:
			velocity.x += direction * (player.acceleration * delta)
			if velocity.x < (player.maxVelocity * -1):
				velocity.x -= move_toward(velocity.x, velocity.x - (player.maxVelocity * -1), player.dampening)
		# No Input
		else:
			velocity.x += move_toward(velocity.x, 0, player.deceleration)

	else:
		velocity.x += move_toward(velocity.x, 0, player.deceleration)
	return velocity
