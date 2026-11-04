extends Node2D

@export var slam_velocity : Curve

@export var player: Player

# Current Slam Timer Position
var slam_timer: float = 0

# Controls whether the slam timer is active
var slam_timer_active: bool = false

@export_group("Horizontal Influence")
## Rate player accelerates
@export var acceleration : float = 10000.0
##Rate player slows down when no left/right key is pressed
@export var deceleration : float = 4000.0
## Max Horizontal influence speed
@export var maxVelocity : float = 800.0
## How fast player decreases when over max speed
@export var dampening : float = 11000.0
## Multiplier reducing acceleration & deceleration. QA Testers change this!
@export var slam_control_resist: float = .5

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("temp_slam"):
		slam()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if slam_timer_active:
		slam_timer += delta
	else:
		slam_timer = 0
	
	if not is_in_slam():
		slam_timer_active = false
		return
		
	if player.is_on_floor() and is_in_slam():
		player.state = Player.State.NONE
		return

	var sample_point := clampf(slam_timer, 0, slam_velocity.max_domain)
	
	player.velocity.y = slam_velocity.sample(sample_point)
	
	#Horizontal Influencing (literally stolen from player_movement lmaooo)
	var horizontal_influcence := Input.get_axis("move_left", "move_right")
		# Right
	if horizontal_influcence > 0:
		player.velocity.x += horizontal_influcence * (acceleration * delta * slam_control_resist)
		if player.velocity.x > maxVelocity:
			player.velocity.x = move_toward(player.velocity.x, maxVelocity, delta * dampening)
		# Left 
	elif horizontal_influcence < 0:
		player.velocity.x += horizontal_influcence * (acceleration * delta * slam_control_resist)
		if player.velocity.x < (maxVelocity * -1):
			player.velocity.x = move_toward(player.velocity.x, maxVelocity * -1, delta * dampening)
	# No Input
	else:
			player.velocity.x = move_toward(player.velocity.x, 0, delta * deceleration * slam_control_resist)
		
		
		
	player.move_and_slide()
	
func slam() -> void:
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
