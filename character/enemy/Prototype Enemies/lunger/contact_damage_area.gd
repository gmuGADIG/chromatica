extends Area2D
class_name ContactDamageArea

@export var damage : int = 1
@export var attack_color : DamageInfo.AttackColor = DamageInfo.AttackColor.GREEN

func _physics_process(_delta: float) -> void:
	for area in get_overlapping_areas():
		if area is PlayerHitbox:
			var info := DamageInfo.new(damage, attack_color)
			#print("sending damage: ", info.damage, " color: ", info.attack_color)
			area.hit(info)
