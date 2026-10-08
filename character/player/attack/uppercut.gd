extends Node
class_name Uppercut
@export var player : Player
@export var player_movement : PlayerMovement


@export_group("Parameters")

@export var uppercut_vertical_velocity : Curve

#time elapsed in the uppercut.
var uppercut_time: float = 0
#A normalized value for the direction the player is uppercutting in
var uppercut_direction : float


func _input(event : InputEvent) -> void:
	if event.is_action_pressed("temp_uppercut"):
		uppercut()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:	
	if player.state != Player.State.UPPERCUT:
		if player.state == Player.State.UPPERCUT and player.is_on_floor():
			player.state = Player.State.NONE
		return
		
	
	uppercut_time += delta
	
	#sets the uppercut velocities and moves the player according to the curve
	player.velocity.x = 0
	player.velocity.y = uppercut_vertical_velocity.sample(uppercut_time) * uppercut_direction
	player.move_and_slide()
		
	if uppercut_time >= uppercut_vertical_velocity.max_domain:
		player.state = Player.State.NONE
	
	
func uppercut():
	if is_in_uppercut():
		return
		
	uppercut_direction = -1
	uppercut_time = 0
	
	player.state = Player.State.UPPERCUT

# checks if player is in uppercut state
func is_in_uppercut() -> bool:
	return player.state == Player.State.UPPERCUT
