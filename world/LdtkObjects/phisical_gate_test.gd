@tool
extends Node2D

class_name Gate

@export var size:Vector2
#@export var tile:TileData

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#rectangle creation
	var Rect : RectangleShape2D = RectangleShape2D.new()
	Rect.size = size
	#collision
	collision_shape.position.y = -0.5*size.y
	collision_shape.shape = Rect
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta: float) -> void:
	
	##collision_shape.position.y = -0.5*size.y
	##pass
