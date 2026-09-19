extends CharacterBody2D
class_name Player

func _process(delta: float) -> void:
	velocity.x = Input.get_axis("ui_left","ui_right") * 1000
