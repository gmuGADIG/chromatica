@tool

## Entity Post Import, which will read entities from LDTK and translate them to Godot nodes

const Util = preload("res://addons/ldtk-importer/src/util/util.gd")
const SceneTest = preload("res://ldtk/testscenes/transition_zone.tscn")

func post_import(entity_layer: LDTKEntityLayer) -> LDTKEntityLayer:
	var entities: Array = entity_layer.entities
	for entity in entities:
		# Create entity node (simple example)
		var new_transition_zone : TransitionZone = SceneTest.instantiate()
		new_transition_zone.global_position = entity.position
		#var rect : RectangleShape2D = RectangleShape2D.new()
		#rect.size = Vector2(100,100)
		entity_layer.add_child(new_transition_zone)
		new_transition_zone.collision_shape_2d.shape.size = entity.size
		

		# Update 'iid' to reference this entity node
		Util.update_instance_reference(entity.iid, new_transition_zone)

		# Add unresolved reference (e.g. EntityRef field)
		if "Entity_ref" in entity.fields:
			var ref = entity.fields.Entity_ref
			if ref != null:
				new_transition_zone.ref = ref
				Util.add_unresolved_reference(new_transition_zone, "ref")

	return entity_layer
