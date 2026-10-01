extends Node2D
class_name PlayerBrush
@export var player : Player
@export var player_movement : PlayerMovement
@export_group("Dimentions")
@export var brush_width : float = 256
@export var brush_length : float = 256

@export_group("Properties")
#change to a longer time when find out what durration should be
@export var brush_damage : int = 2




func _input(event: InputEvent):
	if event.is_action_pressed("brush_swing"):
		var swung : bool = try_swing()
		if not swung:
			#buffer_timer.start()
			pass

func _process(delta: float) -> void:
	#if not buffer_timer.is_stopped() and player.state == Player.State.NONE:
		#buffer_timer.stop()
		#try_swing()
		pass


func try_swing() -> bool:
	if not player.state == Player.State.NONE:
		return false
	
	if player.is_on_floor() and Input.is_action_pressed("look_up"):
		brush_vertical()
		swing_brush(180*Vector2.UP)
	elif not player.is_on_floor() and Input.is_action_pressed("look_down"):
		brush_vertical()
		swing_brush(180*Vector2.DOWN)
	else:
		brush_horizontal()
		var dir : Vector2 = Vector2(player_movement.last_horizontal_direction,0).normalized()
		swing_brush(100*dir)
	return true

func brush_horizontal() -> void:
	pass

func brush_vertical() -> void:
	pass

func swing_brush(dir : Vector2) -> void:
	player.state = Player.State.BRUSH_SWING
	
