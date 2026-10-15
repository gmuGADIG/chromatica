extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var skewValue := 15
@export var bendGrassAnimSpeed = 0.3
@export var grassReturnAnimSpeed = 5.0

func _on_body_entered(body: Node2D) -> void:
	if (body == get_tree().get_first_node_in_group("player")):
		var direction = global_position.direction_to(body.global_position)
		var skew : int = -direction.x * skewValue
		
		var tween = create_tween()
		tween.tween_property(sprite_2d.material,
		"shader_parameter/skew", 
		skew, 
		bendGrassAnimSpeed
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		
		tween.tween_property(sprite_2d.material,
			"shader_parameter/skew", 
			0.0, 
			grassReturnAnimSpeed
			).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	pass # Replace with function body.
