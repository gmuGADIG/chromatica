extends Area2D
class_name PlayerPickupRegion
@export var paint_bucket_storage : PaintBucketStorage

func _ready() -> void:
	self.area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	print("trying to pick something up")
	if area is PaintBucket:
		paint_bucket_storage.add_paint_bucket()
		area.pickup()
	elif area is Pickup:
		area.pickup()
