extends Area2D
class_name PlayerPickupRegion

func _ready() -> void:
	self.area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is Pickup:
		area.pickup()
