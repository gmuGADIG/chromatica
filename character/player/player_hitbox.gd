extends Area2D
class_name PlayerHitbox

@export var health_component : HealthComponent

# Handles the player taking damage
func hit(damage_info : DamageInfo) -> void:
	if (!health_component.hp): return
	health_component.update_health(-damage_info.damage)
