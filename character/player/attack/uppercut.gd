extends Node

@export var player : Player
@export var player_movement : PlayerMovement

@export var uppercut_vertical_velocity : Curve

		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _input(event : InputEvent) -> void:
	if event.is_action_pressed("temp_uppercut"):
		uppercut()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:	
	if player.is_on_floor():
		player.state = Player.State.NONE
		
	
	
func uppercut():
	if is_in_uppercut():
		return
	
	player.state = Player.State.UPPERCUT
	print("uppercut")

# checks if player is in uppercut state
func is_in_uppercut() -> bool:
	return player.state == Player.State.UPPERCUT
