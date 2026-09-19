extends Area2D
class_name PlayerInteractRegion

func check_for_interactable() -> void:
	var interactables : Array[Interactable]
	interactables.assign(get_overlapping_areas().filter(func(val): return val is Interactable))
	
	if interactables.is_empty():
		return
	
	##Only one interactable
	if interactables.size() == 1 :
		interactables[0].interact()
		return
	
	##Multiple interactables
	var closest_interactable: Interactable = interactables[0]
	for interactable in interactables:
		var found_closer_interactable : bool = (
			self.global_position.distance_to(interactable.global_position) <
			self.global_position.distance_to(closest_interactable.global_position)
		)
		if found_closer_interactable:
			closest_interactable = interactable
	
	closest_interactable.interact()
