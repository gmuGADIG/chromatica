extends Area2D
class_name ObjectHitbox

@export var colorable_component : Colorable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colorable_component.color_changed.connect(color_object)
	pass # Replace with function body.

func color_object() -> void:
	get_parent().modulate = colorable_component.colors[-1]
	pass
