extends "res://pickup/pickup.gd"


func _on_pickedup(player) -> void:
	self.get_children()
	super._on_pickedup(player)
	print("I CAST HEALING SPELL")
	queue_free()
