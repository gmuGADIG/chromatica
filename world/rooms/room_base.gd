@tool
extends Node2D
class_name RoomBase

@export var ldtk_room : LDTKLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if ldtk_room != null:
		return
	
	for child in get_children():
		if child is LDTKLevel:
			ldtk_room = child
			return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
