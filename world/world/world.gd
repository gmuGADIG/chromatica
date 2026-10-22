@tool
extends Node2D
class_name World

@export var player : Player

##Updates the association between iids and the level
@export_category("World Cache")
@export_tool_button("Update World Cache","Reload") var action : Callable = _generate_world_cache
func _generate_world_cache() -> void:
	world_cache = null
	var time_string : Callable = func() -> String:
		return "["+Time.get_time_string_from_system()+"]"
	
	print()
	print_rich("[b]" + time_string.call() + " Generating Room Cache...[/b]")
	const EXPORT_PATH : String = "res://world/world/world_cache.tres"
	const IMPORT_PATH : String = "res://ldtk/levels/"
	
	var loaded_rooms : Array[LDTKLevel]
	var world_cache : WorldCache = WorldCache.new()
	
	var dir : DirAccess = DirAccess.open(IMPORT_PATH)
	if dir == null:
		printerr("Could not open folder")
		return
		
	dir.list_dir_begin()
	for file: String in dir.get_files():
		if not file.ends_with(".scn"):
			continue
		var room_path : String = dir.get_current_dir() + "/" + file
		print_rich("[color=dark_goldenrod]"+time_string.call()+" File found: "+room_path+"[/color]")
		var room : LDTKLevel = load(room_path).instantiate()
		room._ready()
		print(room)
		print(room_path)
		world_cache.add_room(room,room_path)
		print_rich("[color=goldenrod]"+time_string.call()+" Mapped "+room.iid+"[/color]")
		loaded_rooms.append(room)
	
	world_cache.take_over_path(EXPORT_PATH)
	var result : Error = ResourceSaver.save(world_cache,EXPORT_PATH,
		ResourceSaver.FLAG_CHANGE_PATH | ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS
	)
	#for f : RoomData in world_cache.room_data.values():
		#f.room_path = "YHi"
	if result == OK:
		print_rich("[color=lime_green]"+time_string.call()+" Cache Generated Successfully![/color]")
	else:
		print(error_string(result))

	##For some reason queue freeing before saving the resource kills the key & value pairs
	for room : LDTKLevel in loaded_rooms:
		room.queue_free()
	EditorInterface.reload_scene_from_path.call_deferred(scene_file_path)
@export var world_cache : WorldCache

var current_room_iid : String
		

var loaded_rooms : Dictionary[String,LDTKLevel]

func _ready() -> void:
	world_cache = load("res://world/world/world_cache.tres")
	if Engine.is_editor_hint():
		#for room_iid : String in world_cache.room_data.keys():
			#load_room(room_iid)
		pass
	else:
		var iid : String = locate_room(player.global_position,true)
		set_current_room(iid)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if current_room_iid == "":
		printerr("no room loaded")
		return
	
	if not in_room_bounds(current_room_iid,player.global_position):
		set_current_room(locate_room(player.global_position,false))

func set_current_room(iid : String) -> void:
	current_room_iid = iid
	var next_iid_set : Array[String] = [iid]
	#print("curr ", iid)
	load_room(iid)
	
	for neighbor : String in world_cache.room_data[iid].adjacent_rooms:
		#print("nay ", neighbor)
		next_iid_set.append(neighbor)
		load_room(neighbor)
	var to_remove : Array[String] = loaded_rooms.keys().filter(
		func(item : String) -> bool:
			return not next_iid_set.has(item)
	)
	
	for removed_iid : String in to_remove:
		unload_room(removed_iid)
	

func load_room(iid : String) -> LDTKLevel:
	if loaded_rooms.has(iid):
		return null
	
	var room_data : RoomData = world_cache.room_data[iid]
	var new_room : LDTKLevel = load(room_data.room_path).instantiate()
	add_child(new_room)
	new_room.global_position = new_room.world_position
	loaded_rooms.set(iid,new_room)
	
	return new_room

func in_room_bounds(room_iid : String, pos : Vector2) -> bool:
	var current_room : RoomData = world_cache.room_data[room_iid]
	if pos.x < current_room.world_position.x:
		return false
	if pos.y < current_room.world_position.y:
		return false
	if pos.x > current_room.world_position.x + current_room.size.x:
		return false
	if pos.y > current_room.world_position.y + current_room.size.y:
		return false
	
	return true

func unload_room(iid : String) -> void:
	assert(loaded_rooms.has(iid))
	assert(iid != current_room_iid)
	
	var room : LDTKLevel = loaded_rooms[iid]
	loaded_rooms.erase(iid)
	room.queue_free()

func locate_room(pos : Vector2, include_unloaded : bool) -> String:
	var iid_list : Array[String] = (
			world_cache.room_data.keys() if include_unloaded
			else loaded_rooms.keys()
	)
	for iid : String in iid_list:
		var room_data : RoomData = world_cache.room_data[iid]
		if pos.x < room_data.world_position.x:
			continue
		if pos.y < room_data.world_position.y:
			continue
		if pos.x > room_data.world_position.x + room_data.size.x:
			continue
		if pos.y > room_data.world_position.y + room_data.size.y:
			continue
		
		return iid
	return ""
