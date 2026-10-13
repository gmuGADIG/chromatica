class_name DamageInfo
extends Resource


@export var damage : int
@export var attack_color : AttackColor
enum AttackColor {RED,YELLOW,BLUE,ORANGE,GREEN,PURPLE}


# Defaults let Godot create a blank DamageInfo (e.g. when loading a saved one).
func _init(attack_damage : int = 0, color : AttackColor = AttackColor.RED) -> void:
	damage = attack_damage
	attack_color = color
