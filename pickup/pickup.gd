extends Area2D
class_name Pickup

@export var item_area : Area2D

func pickup() -> void:
	print(name + " picked up")
	queue_free()
