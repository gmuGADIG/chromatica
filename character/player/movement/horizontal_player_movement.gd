extends Node

## Player reference and Input Reference
@export var player: CharacterBody2D
@export var playerInput: Node

# Player Movmement variables
@export_category("Movement")
@export var acceleration : float # Rate player accelerates
@export var deceleration : float #Rate player Decreasesƒ
@export var maxVelocity : float # Max Player Speed
@export var dampening : float # How fast player decreases when over max speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	var direction: float = playerInput.GetDirection()
	var velocity : Vector2 = player.velocity
	if direction:
		# Right
		if direction > 0:
			velocity.x += direction * (acceleration * delta)
			if velocity.x > maxVelocity:
				print("Over accelerating: ", velocity)
				velocity.x = move_toward(velocity.x, maxVelocity, delta * dampening)
				print("After Correction: ", velocity.x)
		# Left 
		elif direction < 0:
			velocity.x += direction * (acceleration * delta)
			if velocity.x < (maxVelocity * -1):
				velocity.x = move_toward(velocity.x, maxVelocity * -1, delta * dampening)
	# No Input
	else:
			velocity.x = move_toward(velocity.x, 0, delta * deceleration)

	#Done so the velocity is properly updated
	player.velocity = velocity
	player.move_and_slide()
