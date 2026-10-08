@tool
extends Area2D
class_name Pickupable

signal pickedup

static var PICKUP_COLLISION_MASK = 1<<2

func _ready() -> void:
	collision_layer = PICKUP_COLLISION_MASK
	collision_mask = 0

func pickup(player) -> void:
	pickedup.emit(player)
	print(name + " picked up")
	pass
