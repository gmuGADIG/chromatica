class_name PaintSelector
extends Node

static var unlocked_hues : Array = [
	Paint.Hue.RED,
	Paint.Hue.YELLOW,
	Paint.Hue.BLUE
]

@export var selected_hue : Paint.Hue

var selected_hue_index : int = 0

#func _ready() -> void:
	#pass
	#selected_hue = selectable_hues[current_hue]

# the player can cycle through the colors they have unlocked
# the controls should use one or two buttons to cycle through colors
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_color"):
		selected_hue_index = (selected_hue_index+1) % unlocked_hues.size()
		selected_hue = unlocked_hues[selected_hue]
