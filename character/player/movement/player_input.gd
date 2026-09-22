extends Node
class_name  PlayerInput

@export var vertical_player_movement: VerticalPlayerMovement
@export var player_interact_region : PlayerInteractRegion

@export_group("Jump Buffer")
# Time (seconds) in that a player character may still jump after 
# pressing the jump button.
@export var jump_buffer_time: float = 0.1

var jump_buffer = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if vertical_player_movement.can_jump() && jump_buffer:
		vertical_player_movement.jump()
		jump_buffer = false

func _input(event: InputEvent) -> void:
	
	##Jump Inputs
	if event.is_action_pressed("jump"):
		var jumped : bool = vertical_player_movement.jump()
		if not jumped:
			jump_buffer = true
			get_tree().create_timer(jump_buffer_time).timeout.connect(func() : if jump_buffer: jump_buffer = false)
	elif event.is_action_released("jump"):
		vertical_player_movement.early_release()
	
	##Interact Inputs
	if event.is_action_pressed("interact"):
		player_interact_region.check_for_interactable()
