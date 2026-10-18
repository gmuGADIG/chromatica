extends Node2D
class_name Uppercut
@export var player : Player
@export var player_movement : PlayerMovement


@export_group("Parameters")
@export_range(0.05,10.0) var uppercut_cooldown : float = 0.1
@export var uppercut_vertical_velocity : Curve
@export var uppercut_horizontal_velocity : Curve

var can_uppercut: bool = true
#time elapsed in the uppercut.
var uppercut_time: float = 0
#A normalized value for the direction the player is uppercutting in
var uppercut_direction : float

@onready var uppercut_cooldown_timer : Timer = $UppercutCooldown

func _ready() -> void:
	if not is_equal_approx(uppercut_horizontal_velocity.max_domain,uppercut_vertical_velocity.max_domain):
		printerr("Domains between two uppercut velocities different")

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("temp_uppercut"):
		uppercut()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player.state != Player.State.UPPERCUT:
		##TODO: Add uppercut cooldown timer
		if player.is_on_floor() and uppercut_cooldown_timer.is_stopped():
			can_uppercut = true
		return
	
	uppercut_time += delta
	#sets player state to none when uppercut movement is completed
	if uppercut_time >= uppercut_vertical_velocity.max_domain:
		uppercut_cooldown_timer.start(uppercut_cooldown)
		player.state = Player.State.NONE
		##allows player to uppercut again if on floor
		
	#sets the uppercut velocities and moves the player according to the curve
	player.velocity.x = uppercut_direction * uppercut_horizontal_velocity.sample(uppercut_time)
	player.velocity.y = -uppercut_vertical_velocity.sample(uppercut_time)
	player.move_and_slide()
	
	
	
func uppercut():
	if is_in_uppercut() or not can_uppercut or player.state != Player.State.NONE:
		return
	
	
	uppercut_direction = 1 if player_movement.last_horizontal_direction > 0 else -1
	uppercut_time = 0
	can_uppercut = false
	
	player.state = Player.State.UPPERCUT

# checks if player is in uppercut state
func is_in_uppercut() -> bool:
	return player.state == Player.State.UPPERCUT
