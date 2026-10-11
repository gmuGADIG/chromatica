@tool
class_name TransitionZone
extends Area2D

@export var size : Vector2

func _ready() -> void:
	var rect : RectangleShape2D = RectangleShape2D.new()
	rect.size = size
	$CollisionShape2D.shape = rect
#@export var collision_shape_2d: CollisionShape2D

#func create_shape(size : Vector2) -> void:
	#var rect : RectangleShape2D = RectangleShape2D.new()
	#collision_shape_2d.shape = rect
	#print(collision_shape_2d.shape)
	#rect.size = size
