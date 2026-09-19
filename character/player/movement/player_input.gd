extends Node
class_name  PlayerInput

@export var vertical_player_movement: VerticalPlayerMovement
@export var player_interact_region : PlayerInteractRegion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	
	##Jump Inputs
	if event.is_action_pressed("jump"):
		vertical_player_movement.jump()
	elif event.is_action_released("jump"):
		vertical_player_movement.early_release()
	
	##Interact Inputs
	if event.is_action_pressed("interact"):
		player_interact_region.check_for_interactable()
