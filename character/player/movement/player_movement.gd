extends Node
class_name PlayerMovement
## Player reference and Input Reference
@export var player: CharacterBody2D

# Player Movmement variables
@export_group("Horizontal Movement")
## Rate player accelerates
@export var acceleration : float
##Rate player slows down when no left/right key is pressed
@export var deceleration : float
## Max Player Speed
@export var maxVelocity : float
## How fast player decreases when over max speed
@export var dampening : float 

@export_group("Jump")
##The impulse applied to the p	layer when they jump
@export var jump_velocity : float = -2500.0
##The default vertical acceleration of the player, in px/sec
@export var gravity : float = 4000.0
##If the player lets go of jump while still ascending, their vertical velocity will be multiplied by this number
##to give them better control over the player's jump.
@export_range(0.0,1.0) var early_jump_release_multiplier : float = 0.55
##Time (in seconds) early the player can buffer a jump
@export var jump_buffer_time: float = 0.1
## Time (seconds) that the player can jump after
## falling off a platform.
@export var coyote_time : float = 0.1

var can_early_jump_release : bool = false
var coyote_eligible : bool = false
var last_horizontal_direction : float

@onready var coyote_timer : Timer = $CoyoteTimer
@onready var jump_buffer_timer : Timer = $JumpBuffer


func _input(event: InputEvent) -> void:
	##Jump Inputs
	if event.is_action_pressed("jump"):
		var jumped : bool = jump()
		if not jumped:
			jump_buffer_timer.start(jump_buffer_time)
	elif event.is_action_released("jump"):
		early_release()

func _physics_process(delta: float) -> void:
	walk(Input.get_axis("move_left", "move_right"), delta)
	
	##Coyote detection
	if player.is_on_floor():
		if not jump_buffer_timer.is_stopped():
			jump()
			jump_buffer_timer.stop()
	else:
		if coyote_eligible and player.velocity.y > 0 and coyote_timer.is_stopped():
			coyote_eligible = false
			coyote_timer.start()
		player.velocity.y += gravity * delta
	
	
	player.move_and_slide()
	
	if player.is_on_floor():
		coyote_eligible = true

##----------------------------------------------------------------------
##					HORIZONTAL PLAYER MOVEMENT
##-----------------------------------------------------------------------

# Called every frame. 'delta' is the elapsed time since the previous frame.
func walk(direction: float, delta : float) -> void:
	var velocity : Vector2 = player.velocity
	if direction:
		last_horizontal_direction = direction
		# Right
		if direction > 0:
			velocity.x += direction * (acceleration * delta)
			if velocity.x > maxVelocity:
				velocity.x = move_toward(velocity.x, maxVelocity, delta * dampening)
		# Left 
		elif direction < 0:
			velocity.x += direction * (acceleration * delta)
			if velocity.x < (maxVelocity * -1):
				velocity.x = move_toward(velocity.x, maxVelocity * -1, delta * dampening)
	# No Input
	else:
			velocity.x = move_toward(velocity.x, 0, delta * deceleration)

	#Done so the velocity is properly updated
	player.velocity = velocity

##----------------------------------------------------------------------
##					VERTICAL PLAYER MOVEMENT
##-----------------------------------------------------------------------

func can_jump() -> bool:
	return player.is_on_floor() or not coyote_timer.is_stopped()

# Handle jump.	
func jump() -> bool:
	if not can_jump():
		return false
	player.velocity.y = jump_velocity
	can_early_jump_release = true
	coyote_eligible = false
	return true


func early_release() -> void:
	if can_early_jump_release and player.velocity.y < 0:
		player.velocity.y *= early_jump_release_multiplier
		can_early_jump_release = false
