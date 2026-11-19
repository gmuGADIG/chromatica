extends CanvasLayer

signal screen_switched

@export var transition_duration : float = 0.3
@onready var rect : ColorRect = $ColorRect

func _ready() -> void:
	rect.color.a = 0
	hide()

func play() -> void:
	show()
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(rect,"color:a",1.0,transition_duration)
	await tween.finished
	screen_switched.emit()
	tween = get_tree().create_tween()
	tween.tween_property(rect,"color:a",0.0,transition_duration)
	await tween.finished
	hide()
