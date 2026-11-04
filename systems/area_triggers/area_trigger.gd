@tool
class_name AreaTrigger
extends Area2D

@export var size : Vector2
@export var color : Color

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	var rect : RectangleShape2D = RectangleShape2D.new()
	collision_shape.position.y = -0.5*size.y
	rect.size = size
	collision_shape.shape = rect
	collision_shape.debug_color = color
	collision_shape.debug_color.a = 0.1
#@export var collision_shape_2d: CollisionShape2D

#func create_shape(size : Vector2) -> void:
	#var rect : RectangleShape2D = RectangleShape2D.new()
	#collision_shape_2d.shape = rect
	#print(collision_shape_2d.shape)
	#rect.size = size
