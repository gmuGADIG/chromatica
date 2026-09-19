extends Area2D
class_name Hurtbox

@export var health_component : HealthComponent
# has the variables "maximum_hp" and "hp", this should only touch "hp" var
# This HealthComponent should be from an Enemy, so that the "hp" of health_component
# is how much health left the enemy has, or in this case how much it gained.


func hit(damage_info: DamageInfo) -> void:
	# DamageInfo has the integer variable "damage"
	if health_component.hp:
		health_component.update_health(damage_info.damage)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
