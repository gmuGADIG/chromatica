@tool
extends EditorScript

const EXPORT_PATH : String = "res://world/rooms/room_cache/room_cache.tres"

var directory_paths : Array[String] = [
	"res://world/rooms/blue_domain/",
	"res://world/rooms/red_domain/",
	"res://world/rooms/town/",
	"res://world/rooms/yellow_domain/",
	"res://world/rooms/test_rooms/",
]

func _run() -> void:
	var room_cache : RoomCache = RoomCache.new()
	
	for dir_path in directory_paths:
		var dir : DirAccess = DirAccess.open(dir_path)
		if dir == null:
			printerr("Could not open folder")
			continue
		
		dir.list_dir_begin()
		for file: String in dir.get_files():
			if not file.ends_with(".tscn"):
				continue
			var room_path : String = dir.get_current_dir() + "/" + file
			var room : RoomBase = load(room_path).instantiate()
			room_cache.add_room(room.ldtk_room.iid,room_path)
	
	ResourceSaver.save(room_cache,EXPORT_PATH)
