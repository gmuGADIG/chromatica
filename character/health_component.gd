extends Node

class_name HealthComponent

@export var maximum_hp: int

var hp: int
var deadTime := 180
## Updates maxHP, reserved for the player character.
signal health_changed(new_health:int)

## Sends a signal when health is fully depleted.
signal health_depleted

## Sends a signal when death animation is finished.
signal death_complete
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_health()
	
func _process(delta: float) -> void:
	if(hp <= 0):
		deadTime -= 1
		if(deadTime == 0):
			death_complete.emit()
			heal(maximum_hp + (-1 * hp))
			deadTime = 180

func reset_health() -> void:
	hp = maximum_hp
	deadTime = 180

func hurt(amount : int) -> void:
	if amount < 0:
		printerr("Negative value provided. Please use heal(amount) instead")
	
	_update_health(-amount)

func heal(amount : int) -> void:
	if amount < 0:
		printerr("Negative value provided. Please use hurt(amount) instead")
	
	_update_health(amount)

func _update_health(difference: int) -> void:
	hp += difference
	if hp <= 0:
		health_depleted.emit()
	if hp > maximum_hp:
		hp = maximum_hp
	health_changed.emit(hp)
