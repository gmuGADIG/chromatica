extends HBoxContainer

@export var colorable_component : Color


#const colors = 2
#var current_colors = 0
#var color_arr : Array[TextureRect] = []


#func _draw():
	#draw_circle(Vector2(position.x,position.y), 30, border, false, 8.0)
	#self_modulate = colorable_component

func _ready() -> void:
	$Pip.hide()
	$Pip2.hide()
	#current_colors = 0
	#colored()
	#colorable_component = Color.PINK
	#colored()
	#colorable_component = Color.GREEN
	#colored()
	pass
#
#func colored():
	#var culah = TextureRect.new()
	#culah.texture = preload("res://temp/temp_art/thesun.png")
	#culah.self_modulate = colorable_component
	#culah.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#culah.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	##culah.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	#culah.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	#add_child(culah)
	#
	#color_arr.append(culah)
	#if (color_arr.size() > 2):
		#var orphan = color_arr[0]
		#remove_child(color_arr.pop_front())
		#orphan.queue_free()
	#print("pray to GOD this works")
	#pass
