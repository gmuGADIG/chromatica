@tool
extends Node2D
class_name RoomBase


##Updates the association between iids and the level
@export_tool_button("Update Room Cache","Reload") var action : Callable = _generate_room_cache
func _generate_room_cache() -> void:
	var time_string : Callable = func() -> String:
		return "["+Time.get_time_string_from_system()+"]"
	
	print()
	print_rich("[b]"+time_string.call()+" Generating Room Cache...[/b]")
	const EXPORT_PATH : String = "res://world/rooms/room_cache.tres"
	
	const LEVEL_PATHS : Array[String] = [
		"res://world/rooms/blue_domain/",
		"res://world/rooms/red_domain/",
		"res://world/rooms/town/",
		"res://world/rooms/yellow_domain/",
		"res://world/rooms/test_rooms/",
	]

	var loaded_rooms : Array[RoomBase]
	var room_cache : RoomCache = RoomCache.new()
	
	for dir_path in LEVEL_PATHS:
		var dir : DirAccess = DirAccess.open(dir_path)
		if dir == null:
			printerr("Could not open folder")
			continue
		
		dir.list_dir_begin()
		for file: String in dir.get_files():
			if not file.ends_with(".tscn"):
				continue
			var room_path : String = dir.get_current_dir() + "/" + file
			print_rich("[color=dark_goldenrod]"+time_string.call()+" File found: "+room_path+"[/color]")
			var room : RoomBase = load(room_path).instantiate()
			room._ready()
			room_cache.add_room(room.ldtk_room.iid,room_path)
			print_rich("[color=goldenrod]"+time_string.call()+" Mapped: "+room.ldtk_room.iid+" -> "+file+"[/color]")
			loaded_rooms.append(room)
	var result : Error = ResourceSaver.save(room_cache,EXPORT_PATH)
	if result == OK:
		print_rich("[color=lime_green]"+time_string.call()+" Cache Generated Successfully![/color]")
	else:
		print(error_string(result))
	
	##For some reason queue freeing before saving the resource kills the key & value pairs
	for room : RoomBase in loaded_rooms:
		room.queue_free()



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
