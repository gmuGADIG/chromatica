extends ProgressBar
class_name HealthBar

@export var health_component : HealthComponent

func _ready() -> void:
	health_component.health_changed.connect(_on_health_changed)
	max_value = health_component.maximum_hp
	value = health_component.hp

func _on_health_changed(new_health: int) -> void:
	value = new_health
