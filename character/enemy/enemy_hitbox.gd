extends Area2D
class_name EnemyHitbox


# has the variables "maximum_hp" and "hp", this should only touch "hp" var
# This HealthComponent should be from an Enemy, so that the "hp" of health_component
# is how much health left the enemy has, or in this case how much it gained.
@export var health_component : HealthComponent

# This is the enemy's component that handles saturation.
@export var colorable_component: Colorable

func hit(damage_info: DamageInfo) -> void:
	# DamageInfo has the integer variable "damage"
	if damage_info.attack_color == Paint.Hue.NONE:
		return
	if health_component.hp:
		health_component.hurt(damage_info.damage)
		colorable_component.apply(damage_info.attack_color)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
