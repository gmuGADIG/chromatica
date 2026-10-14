extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#what to do on pickup + death
func _on_pickedup(_player) -> void:
	print("Change the world. My final message. Goodbye")
	queue_free()
