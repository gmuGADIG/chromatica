extends CanvasLayer

signal screen_switched

@export var default_transition_duration : float = 0.3
@onready var rect : ColorRect = $ColorRect

func _ready() -> void:
	rect.color.a = 0
	hide()

func play(transition_out : float = default_transition_duration, transition_in : float = default_transition_duration) -> void:
	show()
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(rect,"color:a",1.0,transition_out)
	await tween.finished
	screen_switched.emit()
	tween = get_tree().create_tween()
	tween.tween_property(rect,"color:a",0.0,transition_in)
	await tween.finished
	hide()
