extends Node
class_name Colorable

@export var color_target : Node2D
signal combo_triggered
signal color_changed
var colors : Array = []

func apply(color : Color) -> void:
	if(colors.size() > 2):
		colors.append(color)
	else:
		colors[0] = colors[1]
		colors[1] = color
	color_changed.emit()

func varnish() -> void:
	if(colors.size() == 2):
		combo_triggered.emit()
	colors = []
