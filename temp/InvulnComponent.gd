extends Node

class_name InvulnComponent

signal invuln_changed(new_state : bool)
@export var default_invuln_length : int
@onready var invuln_timer : Timer = $InvulnTimer

func activate(duration : float = -1 ) -> void:
	invuln_changed.emit()
	if (duration < 0 ):
		invuln_timer.start(default_invuln_length)
	invuln_timer.start(duration)
func timeout():
	invuln_timer.timeout.connect(invuln_changed.emit)
func is_invuln() -> bool:
	if(invuln_timer.is_stopped()):
		return false
	return true
