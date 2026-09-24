class_name Player extends CharacterBody2D

func _process(delta: float) -> void:
	velocity.x = Input.get_axis("ui_left","ui_right") * 1000


func _on_jump_buffer_timeout() -> void:
	pass # Replace with function body.
