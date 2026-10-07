extends Control
class_name FileSelect

signal closed

func open() -> void:
	$HBoxContainer/Start.grab_focus()
	show()

func _on_button_back_pressed() -> void:
	closed.emit()

func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_file("res://world/rooms/test_rooms/build_1_sample.tscn")
