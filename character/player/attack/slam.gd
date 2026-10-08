extends Node

@export var slam_velocity : Curve

@export var player: Player

# Current Slam Timer Position
var slam_timer: float = 0

# Controls whether the slam timer is active
var slam_timer_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("temp_slam"):
		#breakpoint 
		slam()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("player state = ", player.state, ", slam_timer = ", slam_timer)
	
	if slam_timer_active:
		slam_timer += delta
	else:
		slam_timer = 0
	
	if not is_in_slam():
		slam_timer_active = false
		return
		
	if player.is_on_floor() and is_in_slam():
		# breakpoint
		player.state = Player.State.NONE
		return
		
	# Ensure that we're only sampling the velocity in a valid range, between 0 and max_domain.
	var sample_point := clampf(slam_timer, 0, slam_velocity.max_domain)
	
	player.velocity.y = slam_velocity.sample(sample_point)
	#breakpoint
	
	
	
func slam() -> void:	
	# Only allow slam ability if the player is in the air and is not already slamming. 
	if player.is_on_floor() or is_in_slam():
		return
	
	# Set the state to SLAM and nullify the player velocity
	player.state = Player.State.SLAM
	player.velocity = Vector2(0, 0)
	
	# Initiate the slam timer
	self.slam_timer_active = true
	self.slam_timer = 0
	
	
func is_in_slam() -> bool:
	return player.state == Player.State.SLAM
