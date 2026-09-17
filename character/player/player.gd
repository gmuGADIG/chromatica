extends CharacterBody2D
class_name Player


# @export var jump_velocity : float = -2500.0
# @export var gravity : float = 4000.0

# @export_category("Scripts")
# @export var horizontalMovement: Node

# func _physics_process(delta: float) -> void:
# 	# Add the gravity.
# 	if not is_on_floor():
# 		velocity.y += gravity * delta

# 	# Handle jump.
# 	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
# 		velocity.y = jump_velocity

# 	# Get the input direction and handle the movement/deceleration.
# 	# As good practice, you should replace UI actions with custom gameplay actions.

# 	move_and_slide()
