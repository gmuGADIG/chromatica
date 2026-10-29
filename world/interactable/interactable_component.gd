@tool
extends Area2D
class_name Interactable

@export var force: float


signal interacted

static var INTERACTABLE_COLLISION_MASK = 1<<2

enum ColorStates {
	RED, 
	BLUE, 
	YELLOW
}

var current_state : ColorStates = ColorStates.RED

@export var cooldown: float

func _ready() -> void:
	collision_layer = INTERACTABLE_COLLISION_MASK
	collision_mask = 0

func interact() -> void:
	if Dialogue.is_playing():
		return	
	
	interacted.emit()
	print(name + " interacted with")
	pass
