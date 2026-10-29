extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScreenTransition.register_color_rect(self)
	pass # Replace with function body.
