class_name DamageInfo
extends Resource

@export var damage : int
@export var attack_color : Paint.Hue
@export var knockback_force: float = 0
@export var knockback_direction: Vector2 = Vector2.ZERO

func _init(
		_damage: int, 
		_attack_color: Paint.Hue, 
		_knockback_force: float = 0, 
		_knockback_direction: Vector2 = Vector2.ZERO
	) -> void:
	self.damage = _damage
	self.attack_color = _attack_color
	self.knockback_force = _knockback_force
	self.knockback_direction = _knockback_direction
