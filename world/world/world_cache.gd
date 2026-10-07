extends Resource
class_name WorldCache


@export var room_data : Dictionary[String,RoomData]

func _init() -> void:
	pass

func add_room(level : LDTKLevel) -> void:
	var new_room : RoomData = RoomData.new()
	new_room.world_position = level.world_position
	new_room.size = level.size
	for key in level.neighbours:
		new_room.adjacent_rooms.append(key["levelIid"])
	room_data.set(level.iid,new_room)
