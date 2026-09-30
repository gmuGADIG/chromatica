extends Control
class_name FileSelect

signal closed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func open() -> void:
	show()


func _on_button_back_pressed() -> void:
	closed.emit()

func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_file("res://world/rooms/test_rooms/simple_platforms.tscn")
	pass # Replace with function body.
