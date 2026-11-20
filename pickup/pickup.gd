extends Area2D
class_name Pickup

func pickup() -> void:
	print(name + " picked up")
	queue_free()
