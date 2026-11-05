@tool
extends Node2D

class_name Gate

@export var size:Vector2
@export var TotalTiles:int

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var Tile_Map: TileMapLayer = $TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#rectangle creation
	var Rect : RectangleShape2D = RectangleShape2D.new()
	Rect.size = size
	#collision
	collision_shape.position.y = -0.5*size.y
	collision_shape.shape = Rect
	
	##texture
	
	for y in 9:
		Tile_Map.set_cell(Vector2i(0,y), 0, Vector2i( 5, 4), 0)##error around here
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta: float) -> void:
	
	##collision_shape.position.y = -0.5*size.y
	##pass
