extends Node

@export var player : Player
@export var player_movement : PlayerMovement

@export var uppercut_vertical_velocity : Curve

#time elapsed in the uppercut
var uppercut_time: float = 0
#A normalized y value for the direction the player is uppercutting in
var uppercut_direction : float
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _input(event : InputEvent) -> void:
	if event.is_action_pressed("temp_uppercut"):
		uppercut()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:	
	if player.state != Player.State.UPPERCUT:
		if player.is_on_floor():
			player.state = Player.State.NONE
			
	player.velocity.y = uppercut_vertical_velocity.sample(uppercut_time) * uppercut_direction
	player.velocity.y = 0
	player.move_and_slide()
		
	
	
func uppercut():
	if is_in_uppercut():
		return
		
	uppercut_direction = 1 if player_movement.last_horizontal_direction > 0 else -1
	uppercut_time = 0
	
	player.state = Player.State.UPPERCUT
	print("uppercut")

# checks if player is in uppercut state
func is_in_uppercut() -> bool:
	return player.state == Player.State.UPPERCUT
