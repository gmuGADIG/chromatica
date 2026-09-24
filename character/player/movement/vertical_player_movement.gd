extends Node
class_name VerticalPlayerMovement

##A reference to the player
@export var player : Player
@export_group("Jump Parameters")
##The impulse applied to the player when they jump
@export var jump_velocity : float = -2500.0
##The default vertical acceleration of the player, in px/sec
@export var gravity : float = 4000.0
##If the player lets go of jump while still ascending, their vertical velocity will be multiplied by this number
##to give them better control over the player's jump.
@export_range(0.0,1.0) var early_jump_release_multiplier : float = 0.55

var can_early_jump_release : bool = false
var jumping : bool = false
var coyote_eligible : bool = false
@onready var coyote_timer : Timer = $CoyoteTimer as Timer

## Time (seconds) that the player can jump after
## falling off a platform.
@export var coyote_time : float = 0.1

#@onready var input : PlayerInput = PlayerInput

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coyote_timer.wait_time = coyote_time


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not player.is_on_floor():
		if not jumping and player.velocity.y > 0 and coyote_timer.is_stopped():
			coyote_eligible = true
			coyote_timer.start()
		player.velocity.y += gravity * delta
	else:
		jumping = false
	
	
	player.move_and_slide()


func can_jump() -> bool:
	return player.is_on_floor() or coyote_eligible

# Handle jump.	
func jump() -> bool:
	if not can_jump():
		return false
	player.velocity.y = jump_velocity
	can_early_jump_release = true
	jumping = true
	return true


func early_release() -> void:
	if can_early_jump_release and player.velocity.y < 0:
		player.velocity.y *= early_jump_release_multiplier
		can_early_jump_release = false

func _on_coyote_timer_timeout() -> void:
	if coyote_eligible:
		coyote_eligible = false
