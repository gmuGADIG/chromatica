extends Node
class_name EntitySpawner

## The layer from which the entities are spawned.
@export var entity_layer : LDTKEntityLayer

func _ready() -> void:
	var enemies : Array
	var room_transitions : Array
	
	for entity in entity_layer.entities:
		if entity_has_tag(entity, "Enemy"):
			enemies.append(entity)
		elif entity_has_tag(entity, "Room_Transition"):
			room_transitions.append(entity)
			
	print("Enemies: ", enemies.size(), ", Room Transitions: ", room_transitions.size())

## Returns whether the given entity has a specified tag.
func entity_has_tag(entity: Variant, query : String) -> bool:
	if not entity is Dictionary: return false
	
	var definition: Dictionary = entity.get("definition", {})
	if not definition: return false
	
	var tags = definition.get("tags", [])
	return query in tags
