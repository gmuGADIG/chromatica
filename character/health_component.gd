extends Node

class_name Health

@export var maximum_hp: int

var hp: int

signal health_depleted
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_health()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_health() -> void:
	hp = maximum_hp

func update_health(difference: int) -> void:
	hp += difference
	if hp <= 0:
		health_depleted.emit()
