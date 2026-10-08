extends Node

@export var slam_velocity : Curve

@export var player: Player

var slam_timer: float = 0;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("temp_slam"):
		#breakpoint 
		slam()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("player state = ", player.state)

	
	if not is_in_slam():
		return
	
	if player.is_on_floor() and is_in_slam():
		# breakpoint
		player.state = Player.State.NONE
	
func slam() -> void:	
	# Only allow slam ability if the player is in the air and is not already slamming. 
	if player.is_on_floor() or is_in_slam():
		return
	
	player.state = Player.State.SLAM
	
func is_in_slam() -> bool:
	return player.state == Player.State.SLAM
