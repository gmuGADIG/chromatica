extends Area2D

@export var attack_duration: float = 0.2

func _input(event: InputEvent):
	if event.is_action_pressed("attack"):
		# Prevent attacking when already mid-attack
		if monitoring==true: return
		monitoring = true
		print("now true")
		await get_tree().create_timer(attack_duration).timeout
		monitoring = false
		print("now false")
