extends Node
class_name Colorable

@export var color_target : Node2D
signal combo_triggered
signal color_changed
var colors : Array = []

func apply(color : Color) -> void:
	# if the colorable does not have 2 colors, add ther color
	if(colors.size() > 2):
		colors.append(color)
	# if the colorable has 2 colors, move the second color back and replace the second color with the added color
	else:
		colors[0] = colors[1]
		colors[1] = color
	# whenever a color is applied the color has been changed
	color_changed.emit()

func varnish() -> void:
	if(colors.size() == 2):
		combo_triggered.emit()
	colors = []
