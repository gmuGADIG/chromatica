extends ColorRect
class_name Vignette

@export var threshold_percentage : float = 25.0
@export var player_health : PlayerHealthComponent

func _ready() -> void:
	player_health.health_changed.connect(_update_vignette)
	_update_vignette(0)

func _update_vignette(_hp : int) -> void:
	visible = float(player_health.hp)/player_health.maximum_hp <= 0.01*threshold_percentage
