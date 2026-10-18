extends Node2D
class_name Pickup

#what to do on pickup + death
func _on_pickedup(_player) -> void:
	print("Change the world. My final message. Goodbye")
	queue_free()
