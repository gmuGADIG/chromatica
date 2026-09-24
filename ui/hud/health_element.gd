extends MarginContainer

class_name HealthElement

@export var empty : TextureRect
@export var full : TextureRect

# Fill this hit point back up.
func grant() -> void:
	pass
# Take this hit point out.
func revoke() -> void:
	pass
