extends Area2D
class_name PlayerHitbox

@export var health_component : HealthComponent
@export var invuln_component : InvulnComponent

# Handles the player taking damage
func hit(damage_info : DamageInfo) -> void:
	if not can_take_damage():
		return
	if health_component.hp <= 0:
		return
	health_component.hurt(damage_info.damage)
	invuln_component.activate()

func can_take_damage() -> bool:
	if invuln_component.is_invuln():
		return false
	##TODO: connect to parry code
	
	return true
