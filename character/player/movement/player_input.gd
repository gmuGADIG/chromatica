extends Node
class_name  PlayerInput

@export var horizontal_player_movement : HorizonalPlayerMovement
@export var vertical_player_movement: VerticalPlayerMovement
@export var player_interact_region : PlayerInteractRegion

@export_group("Jump Buffer")
# Time (seconds) in that a player character may still jump after 
# pressing the jump button.
@export var jump_buffer_time: float = 0.1

var jump_buffer = false

@onready var jump_buffer_timer : Timer = $JumpBuffer

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if vertical_player_movement.can_jump() && jump_buffer:
		vertical_player_movement.jump()
		jump_buffer = false
	
	horizontal_player_movement.walk(Input.get_axis("ui_left", "ui_right"), delta)

func _input(event: InputEvent) -> void:
	
	##Jump Inputs
	if event.is_action_pressed("jump"):
		var jumped : bool = vertical_player_movement.jump()
		if not jumped:
			jump_buffer = true
			jump_buffer_timer.start(jump_buffer_time)
	elif event.is_action_released("jump"):
		vertical_player_movement.early_release()
	
	##Interact Inputs
	if event.is_action_pressed("interact"):
		player_interact_region.check_for_interactable()


func _on_jump_buffer_timeout() -> void:
	if jump_buffer:
		jump_buffer = false
