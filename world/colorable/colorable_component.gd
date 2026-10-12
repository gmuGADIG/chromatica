extends Node
class_name Colorable

@export var color_target : Node2D
signal combo_triggered
signal color_changed
var colors : Array[Color] = []

func _ready() -> void:
	var options : Array[Color] = [Color.RED,Color.YELLOW,Color.BLUE]
	for i in 15:
		if randi_range(0,3) == 0:
			varnish()
		else:
			apply(options.pick_random())
		print(colors)

func apply(new_color : Color) -> void:
	assert(colors.size() <= 2, "Somehow has too many colors")
	# if the colorable has 2 colors, remove oldest
	if(colors.size() == 2):
		colors.pop_front()
	colors.append(new_color)
	
	# whenever a color is applied the color has been changed
	color_changed.emit()

func varnish() -> void:
	if(colors.size() == 2 and colors[0] != colors[1]):
		combo_triggered.emit()
	colors = []
