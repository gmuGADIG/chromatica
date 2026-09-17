extends Node

@export var speed : float = 800.0
@export var jump_velocity : float = -2500.0
@export var gravity : float = 4000.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not get_parent().is_on_floor():
		get_parent().velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and get_parent().is_on_floor():
		get_parent().velocity.y = jump_velocity

	get_parent().move_and_slide()
