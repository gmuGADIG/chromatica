@tool
extends Node2D

class_name Gate

@export var size:Vector2
@export var location:Vector2

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var Tile_Map: TileMapLayer = $TileMapLayer

@export var TileSize: int = 128
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#rectangle creation
	var Rect : RectangleShape2D = RectangleShape2D.new()
	Rect.size = size
	#collision
	collision_shape.position.y = location.y + (.5 * size.y)
	collision_shape.position.x = location.x + (TileSize/2)
	collision_shape.shape = Rect
	
	##texture
	## tile size is 128
	for i in (size.y / TileSize):
		if i == 0:
			Tile_Map.set_cell(Vector2i(0,i), 0, Vector2i( 0, 0), 0)
		elif (i + 1 == size.y/TileSize):
			Tile_Map.set_cell(Vector2i(0,i), 0, Vector2i( 0, 2), 0)
		else:
			Tile_Map.set_cell(Vector2i(0,i), 0, Vector2i( 0, 1), 0)
			
		
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta: float) -> void:
	
	##collision_shape.position.y = -0.5*size.y
	##pass
