class_name PaintSelector
extends Node

static var unlocked_hues : Array = [
	Paint.Hue.RED,
	Paint.Hue.YELLOW,
	Paint.Hue.BLUE
]

@export var selected_hue : Paint.Hue

var current_color : Paint.Hue = Paint.Hue.RED
var colors : Array = []
var cur : int = 0

var selected_hue_index : int = 0

func _ready() -> void:
	Progression.unlocked_item.connect(add_color)

# the player can cycle through the colors they have unlocked
# the controls should use one or two buttons to cycle through colors
func add_color(color : Progression.Unlockable):
	match color:
			Progression.Unlockable.RED_COLOR:
				colors.append(Paint.Hue.RED)
				current_color = Paint.Hue.RED
			Progression.Unlockable.BLUE_COLOR:
				colors.append(Paint.Hue.BLUE)
				current_color = Paint.Hue.BLUE
			Progression.Unlockable.YELLOW_COLOR:
				colors.append(Paint.Hue.YELLOW)
				current_color = Paint.Hue.YELLOW
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_color"):
		if colors.size() == 0:
			return
		cur = (cur+1) % colors.size()
		current_color = colors[cur]
		print(current_color)
		
		
	if event.is_action_pressed("previous_color"):
		if colors.size() == 0:
			return
		cur = (cur-1)
		if cur < 0:
			cur = colors.size()-1
		current_color = colors[cur]
		print(current_color)
