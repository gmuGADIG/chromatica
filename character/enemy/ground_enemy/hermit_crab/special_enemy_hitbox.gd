class_name SpecialEnemyHitbox
extends EnemyHitbox

signal on_possible_hit(damage_info : DamageInfo)

func hit(damage_info: DamageInfo) -> void:
	on_possible_hit.emit(damage_info)

func true_hit(damage_info: DamageInfo) -> void:
	super.hit(damage_info)
