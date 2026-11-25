extends PaintableObject

@export var force_zone: ForceZone

func _ready() -> void:
	colorable_component.color_changed.connect(_on_color_changed)

func _on_color_changed(new_color: Paint.Hue) -> void:
	force_zone.change_state(new_color)
