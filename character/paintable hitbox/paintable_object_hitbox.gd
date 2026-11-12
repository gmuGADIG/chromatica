extends Area2D
class_name ObjectHitbox

@export var colorable_component : Colorable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func color_object() -> void:
	pass

func hit(damage_info: DamageInfo) -> void:
	# apply the color type to the object.
	colorable_component.apply(damage_info.attack_color)
