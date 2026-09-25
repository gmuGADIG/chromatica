extends Resource
class_name RoomCache

@export var id_to_path : Dictionary[String,String]

func add_room(id : String, path : String) -> void:
	id_to_path.set(id,path)
