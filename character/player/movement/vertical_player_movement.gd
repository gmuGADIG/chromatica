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
#@onready var input : PlayerInput = PlayerInput


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity.y += gravity * delta


func can_jump() -> bool:
	return player.is_on_floor()

# Handle jump.	
func jump() -> bool:
	if not can_jump():
		return false
	player.velocity.y = jump_velocity
	can_early_jump_release = true
	return true


func early_release() -> void:
	if can_early_jump_release and player.velocity.y < 0:
		player.velocity.y *= early_jump_release_multiplier
		can_early_jump_release = false
