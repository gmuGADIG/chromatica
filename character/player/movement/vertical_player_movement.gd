extends Node
class_name VerticalPlayerMovement
@export var speed : float = 800.0
@export var jump_velocity : float = -2500.0
@export var gravity : float = 4000.0
#@onready var input : PlayerInput = PlayerInput
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not get_parent().is_on_floor():
		get_parent().velocity.y += gravity * delta

	# Handle jump.
		get_parent().velocity.y = jump_velocity

	get_parent().move_and_slide()
	
	
	
