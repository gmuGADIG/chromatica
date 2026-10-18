@tool

## Entity Post Import, which will read entities from LDTK and translate them to Godot nodes

const Util = preload("res://addons/ldtk-importer/src/util/util.gd")
const respawn_region_packed = preload("res://system/area_triggers/respawn_region/respawn_region.tscn")
const cutscene_trigger_packed = preload("res://system/area_triggers/cutscene_trigger/cutscene_trigger.tscn")

func post_import(entity_layer: LDTKEntityLayer) -> LDTKEntityLayer:
	var entities: Array = entity_layer.entities
	for entity: Dictionary in entities:
		if not entity_has_tag(entity, "AreaTrigger"):
			continue
		
		var identifier : String = entity.definition["identifier"]
		var area_trigger_packed : PackedScene = (
				respawn_region_packed if identifier == "RespawnRegion"
				else cutscene_trigger_packed if identifier == "CutsceneTrigger"
				else null
		)
		
		if area_trigger_packed == null:
			printerr("Invalid Area Trigger")
			return null
		
		## Create the area trigger
		var new_area_trigger : AreaTrigger = area_trigger_packed.instantiate()
		entity_layer.add_child(new_area_trigger)
		
		new_area_trigger.global_position = entity.position
		new_area_trigger.size = entity.size
		
		
		if new_area_trigger is RespawnRegion:
			new_area_trigger.respawn_point = entity.fields["RespawnPoint"]
		elif new_area_trigger is CutsceneTrigger:
			pass
		else:
			printerr("Invalid Area Trigger")
		
		# Update 'iid' to reference this entity node
		Util.update_instance_reference(entity.iid, new_area_trigger)
		
		# Add unresolved reference (e.g. EntityRef field)
		if "Entity_ref" in entity.fields:
			var ref = entity.fields.Entity_ref
			if ref != null:
				new_area_trigger.ref = ref
				Util.add_unresolved_reference(new_area_trigger, "ref")

	return entity_layer

## Returns whether the given entity has a specified tag.
func entity_has_tag(entity: Variant, query : String) -> bool:
	if not entity is Dictionary: return false
	
	var definition: Dictionary = entity.get("definition", {})
	if not definition: return false
	
	var tags = definition.get("tags", [])
	return query in tags
