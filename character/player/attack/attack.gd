extends Area2D

@export var attack_duration: float = 0.2
#change to a longer time when find out what durration should be

func _input(event: InputEvent):
	if event.is_action_pressed("attack"):
		# Prevent attacking when already mid-attack
		if monitoring==true: return
		#maybe wepon move
		monitoring = true
		print("now true")
		await get_tree().create_timer(attack_duration).timeout
		monitoring = false
		#maybe wepon move back to wherever it came from
		print("now false")
