extends Resource
class_name RoomData

@export var room_path : String
@export var world_position : Vector2
@export var size : Vector2
@export var adjacent_rooms : Array[String]

func _init(path : String) -> void:
	room_path = path
