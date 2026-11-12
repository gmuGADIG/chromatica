extends Node

class_name InvulnComponent

signal invuln_changed(new_state : bool)
@export_custom(PROPERTY_HINT_NONE,"suffix:sec") var default_invuln_length : float = 1.0
@onready var invuln_timer : Timer = $InvulnTimer

var tween : Tween

func _ready() -> void:
	invuln_timer.timeout.connect(invuln_changed.emit)

func activate(duration : float = -1 ) -> void:
	invuln_changed.emit()
	if (duration > 0):
		_start_timer(duration)
	else:
		_start_timer(default_invuln_length)

func _start_timer(duration : float) -> void:
	if invuln_timer.is_stopped():
		invuln_timer.start(duration)
	elif invuln_timer.time_left < duration:
		##Edge case where the player gains invulnerability that extends the previous invuln time
		invuln_timer.start(duration)

func is_invuln() -> bool:
	return not invuln_timer.is_stopped()

func _process(delta: float) -> void:
	if not invuln_timer.is_stopped():
		if tween == null:
			tween = get_tree().create_tween()
			tween.tween_property(get_tree().get_node("Sprite2D"), "modulate", Color.RED, 1.0).set_trans(Tween.TRANS_CUBIC)
			tween.tween_callback(get_tree().get_node("Sprite2D").queue_free)
		pass
	pass
