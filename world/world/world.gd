@tool
extends Node2D
class_name World

@export var player : Player
@export var world_cache : WorldCache

var room_boundry : int = 20
var current_Room : RoomData

##Updates the association between iids and the level
@export_tool_button("Update World Cache","Reload") var action : Callable = _generate_world_cache
func _generate_world_cache() -> void:
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
		world_cache.add_room(room)
		print_rich("[color=goldenrod]"+time_string.call()+" Mapped "+room.iid+"[/color]")
		loaded_rooms.append(room)
	
	world_cache.take_over_path(EXPORT_PATH)
	var result : Error = ResourceSaver.save(world_cache,EXPORT_PATH,
		ResourceSaver.FLAG_BUNDLE_RESOURCES
	)
	
	if result == OK:
		print_rich("[color=lime_green]"+time_string.call()+" Cache Generated Successfully![/color]")
	else:
		print(error_string(result))

	##For some reason queue freeing before saving the resource kills the key & value pairs
	#for room : LDTKLevel in loaded_rooms:
		#room.queue_free()

func _ready() -> void:
	locate_current_room()

func _process(delta: float) -> void:
	if (player.position.x - room_boundry < current_Room.world_position[0] 
		or player.position.x + room_boundry > current_Room.world_position[0] + current_Room.size[0] 
		or player.position.y - room_boundry < current_Room.world_position[1] 
		or player.position.y + room_boundry > current_Room.world_position[1] + current_Room.size[1]): 
		locate_current_room()

func locate_current_room() -> void:
	var roomDataArray : Array[RoomData] = world_cache.room_data.values()
	for i in range(roomDataArray.size()):
		if roomDataArray[i].world_position[0] < player.position[0]:
			if player.position[0] < roomDataArray[i].world_position[0]+roomDataArray[i].size[0]:
				if roomDataArray[i].world_position[1] < player.position[1]:
					if player.position[1] < roomDataArray[i].world_position[1]+roomDataArray[i].size[1]:
						current_Room = world_cache.roomDataArray[i]
			
