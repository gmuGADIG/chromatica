class_name DamageInfo
extends Resource


@export var damage : int
@export var attack_color : Paint.Hue


func _init(attack_damage : int , color : Paint.Hue) -> void:
	damage = attack_damage
	attack_color = color
