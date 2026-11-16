@tool

static func reload_editor(scene_file_path : String) -> void:
	EditorInterface.reload_scene_from_path.call_deferred(scene_file_path)
