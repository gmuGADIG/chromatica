extends Node

@export var horizontal_player_movement : HorizonalPlayerMovement

func _process(delta: float) -> void:
	horizontal_player_movement.walk(Input.get_axis("ui_left", "ui_right"), delta)
