extends Area2D
class_name PlayerHitbox

@export var health_component : HealthComponent

# Handles the player taking damage
func hit(damage_info : DamageInfo) -> void:
	if (!can_take_damage()): return
	if (!health_component.hp): return
	health_component.update_health(-damage_info.damage)

func can_take_damage() -> bool:
	# Todo : Impliment invulnerability aspect
	# Todo : Impliment any extra anti damage aspects
	# Always returns true if the player can take damage.
	return true