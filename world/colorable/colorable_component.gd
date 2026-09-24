extends Node
class_name Colorable

@export var color_target : Node2D
signal combo_triggered
signal color_changed
var colors : Array[Color] = []

func apply(color : Color) -> void:
	# if the colorable does not have 2 colors, add the color
	if(colors.size() > 2):
		colors.append(color)
	else:
		# move second color to first, set second color as the applied color
		colors[0] = colors[1]
		colors[1] = color
	# whenever a color is applied the color has been changed
	color_changed.emit()

func varnish() -> void:
	if(colors.size() == 2 and colors[0] != colors[1]):
		combo_triggered.emit()
	colors = []
