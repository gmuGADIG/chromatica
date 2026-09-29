extends Node
class_name EntitySpawner

## The layer from which the entities are spawned.
@export var entity_layer : LDTKEntityLayer

func _ready() -> void:
	var enemies : Array
	var room_transitions : Array
	
	for entity in entity_layer.entities:
		if entity.identifier == "BasicEnemy": #TODO: replace this with tag-based separation
			enemies.append(entity)
		elif entity.identifier == "RoomTransition": #TODO: replace this with tag-based separation
			room_transitions.append(entity)
