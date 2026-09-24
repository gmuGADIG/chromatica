extends HBoxContainer

@export var colorable_component : Color
var border : Color = Color.GRAY
var base : Sprite2D
const colors = 2
var current_colors = 0
var color_arr : Array[String] = []

#func _draw():
	#draw_circle(Vector2(position.x,position.y), 30, border, false, 8.0)
	#self_modulate = colorable_component

func _ready() -> void:
	current_colors = 0
	colored()
	colorable_component = Color.PINK
	#colored()
	pass

func colored():
	var culah = Sprite2D.new()
	culah.texture = preload("res://temp/temp_art/thesun.png")
	culah.self_modulate = colorable_component
	add_child(culah)
	
	color_arr.append(culah.name)
	if (color_arr.size() > 2):
		var orphan = color_arr[0]
		remove_child(color_arr.pop_front())
		orphan.queue_free()
	print("pray to GOD this works")
	pass
