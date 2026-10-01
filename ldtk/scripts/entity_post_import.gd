@tool

## Entity Post Import, which will read entities from LDTK and translate them to Godot nodes

const Util = preload("res://addons/ldtk-importer/src/util/util.gd")
const SceneTest = preload("res://ldtk/testscenes/area_trigger.tscn")

func post_import(entity_layer: LDTKEntityLayer) -> LDTKEntityLayer:
	var entities: Array = entity_layer.entities
	for entity in entities:
		if not entity_has_tag(entity, "AreaTrigger"):
			continue
		# Create entity node (simple example)
		var new_transition_zone : AreaTrigger = SceneTest.instantiate()
		entity_layer.add_child(new_transition_zone)
		
		new_transition_zone.global_position = entity.position
		new_transition_zone.size = entity.size
		#new_collision_shape.shape.size = entity.size
		
		#print(new_transition_zone.owner)
		#print(new_transition_zone.get_children())
		
		##var rect : RectangleShape2D = RectangleShape2D.new()
		##rect.size = Vector2(100,100)
		#
		#new_transition_zone.collision_shape_2d.shape.size = entity.size
		#

		# Update 'iid' to reference this entity node
		Util.update_instance_reference(entity.iid, new_transition_zone)
		#Util.update_instance_reference(entity.iid, new_collision_shape)
		
		# Add unresolved reference (e.g. EntityRef field)
		if "Entity_ref" in entity.fields:
			var ref = entity.fields.Entity_ref
			if ref != null:
				new_transition_zone.ref = ref
				Util.add_unresolved_reference(new_transition_zone, "ref")

	return entity_layer
## Returns whether the given entity has a specified tag.
func entity_has_tag(entity: Variant, query : String) -> bool:
	if not entity is Dictionary: return false
	
	var definition: Dictionary = entity.get("definition", {})
	if not definition: return false
	
	var tags = definition.get("tags", [])
	return query in tags
