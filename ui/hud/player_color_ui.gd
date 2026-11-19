extends Control

@export var player_paint_selector: PaintSelector

func _ready() -> void:
	player_paint_selector.selected_color_changed.connect(_on_color_changed)

func _on_color_changed(new_color: Paint.Hue) -> void:
	match new_color:
		Paint.Hue.RED:
			modulate = Color(1.0, 0.0, 0.0, 1.0)
		Paint.Hue.YELLOW:
			modulate = Color(1.0, 0.775, 0.1, 1.0)
		Paint.Hue.BLUE:
			modulate = Color(0.1, 0.745, 1.0, 1.0)
