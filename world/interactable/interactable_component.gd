@tool
extends Area2D
class_name Interactable

signal interacted

static var INTERACTABLE_COLLISION_MASK = 1<<2

func _ready() -> void:
	collision_layer = INTERACTABLE_COLLISION_MASK
	collision_mask = 0

func interact() -> void:
	interacted.emit()
	print(name + " interacted with")
	pass
