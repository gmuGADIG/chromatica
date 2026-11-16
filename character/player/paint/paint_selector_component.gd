class_name PaintSelector
extends Node

@export var selected_hue : Paint.Hue

var current_color : Paint.Hue = Paint.Hue.RED
var colors : Array[Paint.Hue] = [Paint.Hue.RED]
var current_index : int = 0

signal selected_color_changed(new_color: Paint.Hue)

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
			_:
				#unlock was not a hue
				pass
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_color"):
		if colors.size() == 1:
			return
		current_index += 1
		if current_index >= colors.size(): current_index = 0
		current_color = colors[current_index]
		print(current_color)
		selected_color_changed.emit(current_color)
		
		
	if event.is_action_pressed("previous_color"):
		if colors.size() == 1:
			return
		current_index -= 1
		if current_index < 0: current_index = colors.size()-1
		current_color = colors[current_index]
		print(current_color)
		selected_color_changed.emit(current_color)
