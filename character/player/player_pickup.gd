extends Area2D
class_name PlayerPickupRegion

func _process(_delta: float) -> void:
	check_for_pickup()

func check_for_pickup() -> void:
	var pickups : Array[Pickupable]
	pickups.assign(get_overlapping_areas().filter(func(val): return val is Pickupable))
	if pickups.is_empty():
		return
	#pick up items in order of age
	pickups[0].pickup(self.get_parent())
