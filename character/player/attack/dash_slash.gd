extends Node
class_name DashSlash
@export var player: Player
@export var player_movement: PlayerMovement



@export_group("Parameters")
#seconds before player can dash again
@export var dash_slash_cooldown: float = 0

#curve that defines velocity of slash based on seconds.
@export var dash_slash_velocity: Curve

#if dashing is possible.
var can_dash_slash: bool = false
#time elapsed in a dash.
var dash_slash_time: float = 0
#A normalized x value for the direction the player is dashing in
var dash_direction : float

@onready var dash_slash_cooldown_timer : Timer = $DashSlashCooldown

func _ready() -> void:
	pass

func _input(event: InputEvent):
	if event.is_action_pressed("temp_dash"):
		dash_slash()
	pass

func _physics_process(delta: float) -> void:
	if player.state != Player.State.DASH_SLASH:
		if player.is_on_floor() and dash_slash_cooldown_timer.is_stopped():
			can_dash_slash = true
		return
	
	
	dash_slash_time += delta
	if dash_slash_time >= dash_slash_velocity.max_domain:
		if dash_slash_cooldown > 0.05: ##Timers have a soft minimum
			dash_slash_cooldown_timer.start(dash_slash_cooldown)
		player.state = Player.State.NONE
	
	player.velocity.x = dash_slash_velocity.sample(dash_slash_time) * dash_direction
	player.velocity.y = 0
	player.move_and_slide()
	print(player.state)

func dash_slash() -> void:
	if is_dashing_slashing() or not can_dash_slash:
		return
	## dashing is true, resets time elapsed.
	dash_direction = 1 if player_movement.last_horizontal_direction > 0 else -1
	dash_slash_time = 0
	can_dash_slash = false
	player.state = Player.State.DASH_SLASH

func is_dashing_slashing() -> bool:
	return player.state == player.State.DASH_SLASH
	
