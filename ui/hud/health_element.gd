extends Control

class_name HealthElement

# Empty is the base sprite, while full is the overlay
# Empty should remain unchanged, while full can be shown or hidden
@export var empty : TextureRect
@export var full : TextureRect

# Fill this hit point back up.
func grant() -> void:
	full.show()

# Take this hit point out.
func revoke() -> void:
	full.hide()
