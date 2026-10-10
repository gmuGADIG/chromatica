extends Area2D
class_name PlayerHitbox

@export var health_component : HealthComponent
@export var invuln_component : InvulnComponent

# Handles the player taking damage
func hit(damage_info : DamageInfo) -> void:
	if (!can_take_damage()): return
	if (health_component.hp <= 0): return
	health_component._update_health(-damage_info.damage)
	print (health_component.hp, damage_info.damage)
	if invuln_component:
		invuln_component.activate()

func can_take_damage() -> bool:
	# Todo : Impliment invulnerability aspect
	# Todo : Impliment any extra anti damage aspects
	# Always returns true if the player can take damage.
	
	return invuln_component == null or not invuln_component.is_invuln()
	#return true
