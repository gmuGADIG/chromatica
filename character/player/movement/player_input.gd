extends Node
class_name  PlayerInput
@export var wants_to_jump: bool = false
@export var vertical_player_movement: VerticalPlayerMovement
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		vertical_player_movement.jump()
		
