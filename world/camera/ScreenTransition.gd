extends ColorRect

var color_rect : ColorRect = null

func register_color_rect(rect : ColorRect) -> void:
	color_rect = rect

func play_room_transition(time : float) -> void:
	if color_rect == null:
		return
	var dir : int = 1
	var speed : float = 1/time
	color_rect.modulate.a = 0.0
	color_rect.modulate.a += 0.01
	while color_rect.modulate.a > 0:
		if color_rect.modulate.a >= 1:
			dir *= -1
		color_rect.modulate.a += speed * dir * get_process_delta_time()
		print(color_rect.modulate.a)
		await get_tree().process_frame 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
