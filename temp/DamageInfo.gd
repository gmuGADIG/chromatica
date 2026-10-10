class_name DamageInfo
extends Resource


@export var damage : int = 0 #Placeholder Parameter
@export var attack_color : AttackColor = AttackColor.RED #Placeholder Parameter
enum AttackColor {RED,YELLOW,BLUE,ORANGE,GREEN,PURPLE}


func _init(attack_damage : int = 0, color : AttackColor = AttackColor.RED) -> void:
	damage = attack_damage
	attack_color = color
