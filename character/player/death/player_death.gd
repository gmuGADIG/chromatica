extends Node
class_name PlayerDeath

@export var player : Player
@export var health_component : HealthComponent

func _ready() -> void:
	health_component.health_depleted.connect(_on_death)

func _on_death() -> void:
	player.state = Player.State.DEAD
	await get_tree().create_timer(1)
	#var tween : Tween = get_tree().create_tween()
	#tween.tween_property()
	ScreenTransition.play(3.0)
	await ScreenTransition.screen_switched
	get_tree().reload_current_scene()
	pass
