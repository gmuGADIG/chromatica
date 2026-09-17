extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		check_for_interactable()
		
func check_for_interactable() -> void:
	var closest_interactable: Interactable = null
	var areas = get_overlapping_areas()
	if areas.size() == 0 or areas == null:
		return
	if areas.size() > 0 :
		if areas[0] is Interactable:
			closest_interactable = areas[0]
	if areas.size() > 1 :
		for area in areas:
			if area is not Interactable:
				continue
			if(closest_interactable == null):
				closest_interactable = area
			if(self.global_position.distance_to(area.global_position) < self.global_position.distance_to(closest_interactable.global_position)):
				closest_interactable = area
	if closest_interactable != null:
		closest_interactable.interact()
