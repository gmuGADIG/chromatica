class_name DamageInfo
extends Resource


@export var damage : int
@export var attack_color : AttackColor
enum AttackColor {RED,YELLOW,BLUE,ORANGE,GREEN,PURPLE}


func _init(AttackDamage,color) -> void:
	var damage = AttackDamage
	var attack_color = color
