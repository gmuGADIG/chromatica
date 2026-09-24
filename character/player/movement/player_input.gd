extends Node

@export var coyote_time : float = 0

@onready var player_root : Player = $"../Player" as Player
@onready var coyote_timer : Timer = $InputComponent/CoyoteTimer as Timer
var coyote_eligible : bool = false



func handle_jump() -> void:
	# Handle basic jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		player_root.velocity.y = jump_velocity
	# Handle coyote jump
	elif Input.is_action_just_pressed("ui_accept") and velocity.y < 0 and coyote_time < 0.1:
		player_root.velocity.y = jump_velocity
	
