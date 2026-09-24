extends Node
class_name Colorable

@export var color_target : Node2D
signal combo_triggered
signal color_changed
var colors : Array[Color] = []

func apply(new_color : Color) -> void:
	assert(colors.size() <= 2, "Somehow has too many colors")
	# if the colorable does not have 2 colors, add the color
	if(colors.size() < 2):
		colors.append(new_color)
		# move second color to first, set second color as the applied color
		colors[0] = colors[1]
		colors[1] = new_color
	# whenever a color is applied the color has been changed
	color_changed.emit()

func varnish() -> void:
	if(colors.size() == 2 and colors[0] != colors[1]):
		combo_triggered.emit()
	colors = []
