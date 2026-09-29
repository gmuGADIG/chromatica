extends Node2D

@export var ldtk_level : LDTKLevel
@export var player_movement : PlayerMovement
@export var player : Player
@export_group("Horizontal")
@export var stationary_horizontal_offset : float = 200
@export var camera_speed_horizontal : Curve
@export_group("Vertical")
@export var camera_speed_vertical : float = 750
		
var relative_position : Vector2 = Vector2.ZERO

@onready var camera : Camera2D = $Node/Camera2D

func _ready() -> void:
	camera.limit_left = ldtk_level.world_position.x
	camera.limit_top = ldtk_level.world_position.y
	camera.limit_right = ldtk_level.world_position.x + ldtk_level.size.x
	camera.limit_bottom = ldtk_level.world_position.y + ldtk_level.size.y
	camera.global_position = global_position
	
func _process(delta: float) -> void:
	move_x(delta)
	move_y(delta)
	#camera.position.x = stationary_horizontal_offset * player_movement.last_horizontal_direction
	pass

func move_x(delta : float) -> void:
	#camera.position.x += 1
	var input_dir : float = Input.get_axis("move_left","move_right")
	if input_dir:
		if (camera.global_position.x - global_position.x) * input_dir > 80:
			## Moving TOWARDS the camera
			var diff : float = global_position.x-camera.global_position.x+relative_position.x
			relative_position.x -= diff
		else:
			## Moving away from the camera
			var dist : float = absf(relative_position.x)
			var tween_speed : float = camera_speed_horizontal.sample(dist*2.0)
			relative_position.x = move_toward(relative_position.x,0,tween_speed*delta)
	else:
		## Stationary
		var target_x : float = stationary_horizontal_offset * player_movement.last_horizontal_direction
		var dist : float = absf(relative_position.x - target_x)
		print(dist)
		var tween_speed : float = camera_speed_horizontal.sample(dist)
		relative_position.x = move_toward(relative_position.x,target_x,tween_speed*delta)
	
	camera.position.x = global_position.x + relative_position.x

func move_y(delta : float) -> void:
	
	var diff : float = global_position.y-camera.global_position.y+relative_position.y
	relative_position.y -= diff
	
	#var input_dir : float = Input.get_axis("look_up","look_down")
	#if input_dir:
	if camera.global_position.y > global_position.y:
		##Normal Camera Behavior
		relative_position.y = move_toward(relative_position.y,0,camera_speed_vertical*delta)
	else:
		relative_position.y = 0
	
	camera.position.y = global_position.y + relative_position.y
