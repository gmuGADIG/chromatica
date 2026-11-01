class_name DamageInfo
extends Resource


@export var damage : int
@export var attack_color : AttackColor
enum AttackColor {RED,YELLOW,BLUE,ORANGE,GREEN,PURPLE}


func _init(attack_damage : int , color : AttackColor) -> void:
	damage = attack_damage
	attack_color = color
