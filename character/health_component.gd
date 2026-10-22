extends Node

class_name HealthComponent

@export var maximum_hp: int

var hp: int
## Updates maxHP, reserved for the player character.
signal health_changed(new_health:int)

## Sends a signal when health is fully depleted.
signal health_depleted
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressionSystem.collected_bead.connect(on_bead_collect)
	reset_health()

func on_bead_collect(bead : Bead.BeadType,total : int) -> void:
	if bead == Bead.BeadType.HIT_POINTS and total <= 6 and total % 2 ==0:
		maximum_hp += 5
	
func reset_health() -> void:
	hp = maximum_hp

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
