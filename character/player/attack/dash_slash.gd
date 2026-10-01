extends Node
class_name DashSlash
@export var player: Player
@export var player_movement: PlayerMovement

#time elapsed in a dash.
@export var dash_slash_time: float = 0;

#how long a given dash lasts.
@export var dash_slash_duration: float = 0;

#curve that defines velocity of slash based on seconds.
@export var dash_slash_velocity: Curve


func _ready() -> void:
	pass

func _input(event: InputEvent):
	if event.is_action_pressed("temp_dash"):
		dash_slash()
	pass

func _process(delta: float) -> void:
	dash_slash_time += delta
	var directional_mult = 0
	if player_movement.last_horizontal_direction > 0:
		directional_mult = 1;
	if player_movement.last_horizontal_direction < 0:
		directional_mult = -1;
	if player.state == Player.State.DASH_SLASH:
		if dash_slash_time >= 1.0:
			player.state = Player.State.NONE
		else:
			player.velocity.x = dash_slash_velocity.sample(dash_slash_time) * directional_mult
			player.velocity.y = 0
			player.move_and_slide()
func dash_slash() -> void:
	if is_dashing_slashing():
		return
	## dashing is true, resets time elapsed.
	dash_slash_time = 0
	player.state = Player.State.DASH_SLASH

func is_dashing_slashing() -> bool:
	return player.state == player.State.DASH_SLASH
	
